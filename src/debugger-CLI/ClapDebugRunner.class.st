Class {
	#name : 'ClapDebugRunner',
	#superclass : 'ClapPharoApplication',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'command line' }
ClapDebugRunner class >> commandSpecification [

	<commandline>
	| spec |
	spec := (ClapCommandSpec id: #debug)
		        commandClass: self;
		        description: 'A Debug runner to launch debugger from a shell';
		        addHelp;
		        addPositional: #EXPR spec: [ :positional |
				        positional
					        description: 'Debug this code';
					        multiple: true ];
		        yourself.

	self
		addSaveFlagTo: spec;
		addRenameOptionTo: spec.
	^ spec
]

{ #category : 'private - printing' }
ClapDebugRunner >> askTyping [

	self outputStreamDo: [ :out |
			out
				<< '(debug) ';
				flush ]
]

{ #category : 'execution' }
ClapDebugRunner >> createDebuggingProcess [
	"Extracts the expression, compiles it, and returns a suspended process."

	| codeToDebug codeString blockToDebug process |
	codeToDebug := self hasExpresion
		               ifFalse: [ ^ nil ]
		               ifTrue: [ self expressionToDebug ].
	codeString := codeToDebug joinUsing: ' '.

	blockToDebug := OpalEvaluator new evaluate: '[ ' , codeString , ' ]'.

	process := blockToDebug newProcess.
	process suspend.
	^ process
]

{ #category : 'execution' }
ClapDebugRunner >> execute [

	self prepareImageAndExit.

	self startLoop.

	self exitSuccess
]

{ #category : 'execution' }
ClapDebugRunner >> expressionToDebug [

	self hasExpresion ifTrue: [ ^ self positional: #EXPR ]
]

{ #category : 'execution' }
ClapDebugRunner >> handleZnIncompleteErrorInInput: ex [
	"We automatically get a ZnIncomplete error when we use nextLine, so this is a way to handle it :
	We wait 50ms until we get user's input."

	ex class name = #ZnIncomplete
		ifTrue: [ (Delay forMilliseconds: 50) wait ]
		ifFalse: [ ex pass ]
]

{ #category : 'execution' }
ClapDebugRunner >> hasExpresion [
	"Return True if the EXPR flag is set"

	^ self hasFlag: #'EXPR'
]

{ #category : 'private - printing' }
ClapDebugRunner >> informResults: results [

	self outputStreamDo: [ :out |
			(out << results)
				<< OSPlatform current lineEnding;
				flush ]
]

{ #category : 'execution' }
ClapDebugRunner >> readNextLineFrom: inStream [
	"create a nil input waiting for the user to type something, handling ZnIncomplete Error. Returns the input"

	| input |
	input := nil.

	[ input isNil ] whileTrue: [
			[ input := inStream nextLine ]
				on: Error
				do: [ :ex | self handleZnIncompleteErrorInInput: ex ] ].

	^ input
]

{ #category : 'execution' }
ClapDebugRunner >> startLoop [
	"Start a loop launching a debugger with a context and process depending of the flag expr, waiting for the user's commands"

	| input in tempRes debugger debuggingProcess debuggingContext debuggingSession |
	in := self context stdin.

	debuggingProcess := self createDebuggingProcess.
	debuggingProcess ifNil: [
			self inform: 'No expression found' , String lf , 'usage: debug <expression>'.
			^ self ].
	debuggingContext := debuggingProcess suspendedContext.
	debuggingSession := DebugSession named: 'd' on: debuggingProcess startedAt: debuggingContext.
	debugger := CommandLineDebugger new
		            process: debuggingProcess;
		            context: debuggingContext;
		            session: debuggingSession.

	self inform: '--------------- Debug phase started ---------------'.
	self inform: '  For help, type "help"'.

	[ debugger isActive ] whileTrue: [
			self askTyping.
			input := self readNextLineFrom: in.

			tempRes := debugger parsesAndExecuteCommand: input asString.

			self informResults: tempRes ].
	^ self
]
