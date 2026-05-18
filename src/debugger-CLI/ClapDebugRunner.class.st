Class {
	#name : 'ClapDebugRunner',
	#superclass : 'ClapPharoApplication',
	#instVars : [
		'debugger'
	],
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

{ #category : 'creation' }
ClapDebugRunner >> createDebugger: debuggingProcess [

	| debuggingContext debuggingSession |
	debuggingContext := debuggingProcess suspendedContext.
	debuggingSession := DebugSession named: 'debugger' on: debuggingProcess startedAt: debuggingContext.
	debugger := CommandLineDebugger new
		            process: debuggingProcess;
		            context: debuggingContext;
		            session: debuggingSession;
		            inStream: self context stdin;
		            outStream: self context stdout.
	^ debugger
]

{ #category : 'execution' }
ClapDebugRunner >> createDebuggingProcess [
	"Extracts the expression, compiles it, and returns a suspended process."

	| codeToDebug codeString blockToDebug process |
	codeToDebug := self expressionToDebug.
	codeString := codeToDebug joinUsing: ' '.

	blockToDebug := OpalEvaluator new evaluate: '[ ' , codeString , ' ]'.

	process := blockToDebug newProcess.
	process suspend.
	^ process
]

{ #category : 'execution' }
ClapDebugRunner >> execute [

	self prepareImageAndExit.

	self runDebugger.

	self exitSuccess
]

{ #category : 'execution' }
ClapDebugRunner >> expressionToDebug [

	^ self positional: #EXPR 
]

{ #category : 'execution' }
ClapDebugRunner >> runDebugger [
	"Create a debugger and run it"

	| debuggingProcess |
	[ debuggingProcess := self createDebuggingProcess ]
		on: Error
		do: [ :e |
				self inform: 'Cannot create process; Usage: debug <expression>. Error details : ' , OSPlatform current lineEnding , e asString.
				^ self ].

	debugger := self createDebugger: debuggingProcess.
	debugger run
]
