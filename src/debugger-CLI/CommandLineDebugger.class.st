"
A class to execute commands from command Line.
We can parse commands and arguments, and execute the dedicated method
"
Class {
	#name : 'CommandLineDebugger',
	#superclass : 'Object',
	#instVars : [
		'isActive',
		'context',
		'process',
		'lineEnding',
		'commands',
		'commandsStack',
		'session',
		'inStream',
		'outStream'
	],
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'as yet unclassified' }
CommandLineDebugger class >> forCode: aString [
    "Compiles the code, create a process from it then build the debugger"
    
    | blockToDebug process |
    blockToDebug := OpalEvaluator new evaluate: '[ ' , aString , ' ]'.
    process := blockToDebug newProcess.
    process suspend.
    
    ^ self forProcess: process
]

{ #category : 'as yet unclassified' }
CommandLineDebugger class >> forProcess: aProcess [
    "Create a debugger from a given process"
    
    | debuggingContext debuggingSession |
    debuggingContext := aProcess suspendedContext.
    debuggingSession := DebugSession named: 'debugger' on: aProcess startedAt: debuggingContext.
    
    ^ self new
        process: aProcess;
        context: debuggingContext;
        session: debuggingSession;
        yourself
]

{ #category : 'initialization' }
CommandLineDebugger >> activate [

	isActive := true
]

{ #category : 'private - printing' }
CommandLineDebugger >> askTyping [

	outStream 
        << '(debug) '; 
        flush
]

{ #category : 'execution' }
CommandLineDebugger >> commandClassInstanceFor: aString [
	"Gives the right command class to use"

	[ ^ commands at: aString ]
		on: Error
		do: [ :ex |
				ex class name = #KeyNotFound
					ifTrue: [ ^ UnknownCommand new command: aString ]
					ifFalse: [ ex pass ] ]
]

{ #category : 'accessing' }
CommandLineDebugger >> commands [

	^ commands
]

{ #category : 'accessing' }
CommandLineDebugger >> commands: anObject [

	commands := anObject
]

{ #category : 'accessing' }
CommandLineDebugger >> commandsStack [

	^ commandsStack
]

{ #category : 'accessing' }
CommandLineDebugger >> commandsStack: anObject [

	commandsStack := anObject
]

{ #category : 'initialization' }
CommandLineDebugger >> context [

	^ context
]

{ #category : 'initialization' }
CommandLineDebugger >> context: aDebugContext [
    context := aDebugContext
]

{ #category : 'initialization' }
CommandLineDebugger >> disActivate [

	isActive := false
]

{ #category : 'execution' }
CommandLineDebugger >> executeCommand: aCommand arg: arguments [
	"executes the command with potential arguments"

	^ (self commandClassInstanceFor: aCommand) executeOn: self with: arguments
]

{ #category : 'execution' }
CommandLineDebugger >> finishedDebugging [

	isActive := false.
	^ 'Execution finished. The program has ended.'
]

{ #category : 'execution' }
CommandLineDebugger >> handleHistory: aString [
	"Handles all the history related commands"

	| trimmed |
	trimmed := aString trim.
	(trimmed beginsWith: '!!') ifTrue: [ ^ self lastCommand , (trimmed allButFirst: 2) ].

	(trimmed beginsWith: '!?') ifTrue: [ ^ self handleWordMatchingHistory: trimmed ].

	(trimmed beginsWith: '!') ifTrue: [ ^ self handleNumericHistory: trimmed ].


	^ aString
]

{ #category : 'initialization' }
CommandLineDebugger >> handleNumericHistory: aString [
	"Handles command !<anInteger> and return (if it exists) the command related to the number
	ex : !-2 returns the second last command
		  !2 returns the second command "

	| indexString targetIndex commandsArray |
	indexString := aString allButFirst.

	targetIndex := indexString asInteger.
	targetIndex isInteger ifFalse: [ ^ aString ]. "checking if it is a number. If not, return the string typed by the user"
	commandsArray := self commandsStack asArray.

	targetIndex < 0 ifTrue: [ ^ commandsArray at: targetIndex abs ifAbsent: [ 'No-history-for-this-index' ] ].

	targetIndex > 0 ifTrue: [ ^ commandsArray at: commandsArray size - targetIndex + 1 ifAbsent: [ 'No-history-for-this-index' ] ].

	^ aString
]

{ #category : 'initialization' }
CommandLineDebugger >> handleWordMatchingHistory: aString [
	"Handles the command !?<aString> and return (if it exists) the last command typed contaning aString"

	| unMot commandsArray |
	unMot := aString copyFrom: 3 to: aString size.

	commandsArray := self commandsStack asArray.
	^ commandsArray detect: [ :command | command includesSubstring: unMot ] ifNone: [ 'no-match-found' ]
]

{ #category : 'execution' }
CommandLineDebugger >> handleZnIncompleteErrorInInput: ex [
	"We automatically get a ZnIncomplete error when we use nextLine, so this is a way to handle it :
	We wait 50ms until we get user's input."

	ex class name = #ZnIncomplete
		ifTrue: [ (Delay forMilliseconds: 50) wait ]
		ifFalse: [ ex pass ]
]

{ #category : 'accessing' }
CommandLineDebugger >> inStream [

	^ inStream
]

{ #category : 'accessing' }
CommandLineDebugger >> inStream: anObject [

	inStream := anObject
]

{ #category : 'initialization' }
CommandLineDebugger >> initialize [

	super initialize.
	isActive := true.
	lineEnding := OSPlatform current lineEnding.
	self initializeCommands.
	commandsStack := Stack new.
]

{ #category : 'initialization' }
CommandLineDebugger >> initializeCommands [

	| commandsList |
	commandsList := {
		                ExitCommand new.
		                HelpCommand new.
		                StepCommand new.
		                OverCommand new.
		                PrintCodeCommand new.
		                PrintCommand new.
		                PrintStackCommand new.
		                HistoryCommand new }.
	commands := Dictionary new.
	commandsList do: [ :aCommand |
			commands at: aCommand commandName first put: aCommand.
			commands at: aCommand commandName last put: aCommand ]
]

{ #category : 'initialization' }
CommandLineDebugger >> isActive [
    ^ isActive
]

{ #category : 'initialization' }
CommandLineDebugger >> lastCommand [
	
	commandsStack ifNotEmpty: [ ^ commandsStack pop ]
	ifEmpty: [ ^ '' ]
	
]

{ #category : 'accessing' }
CommandLineDebugger >> lineEnding [

	^ lineEnding
]

{ #category : 'accessing' }
CommandLineDebugger >> lineEnding: anObject [

	lineEnding := anObject
]

{ #category : 'accessing' }
CommandLineDebugger >> outStream [

	^ outStream
]

{ #category : 'accessing' }
CommandLineDebugger >> outStream: anObject [

	outStream := anObject
]

{ #category : 'execution' }
CommandLineDebugger >> parsesAndExecuteCommand: aString [
	"Parses a string to change it into an executable command and executes it"

	| subString command arguments finalString |
	finalString := self handleHistory: aString .
	commandsStack push: finalString.
	subString := finalString substrings.
	subString ifEmpty: [ ^ '' ].

	command := subString first.

	arguments := subString allButFirst joinUsing: ' '.

	^ self executeCommand: command arg: arguments
]

{ #category : 'initialization' }
CommandLineDebugger >> printOutput: output [

	(outStream << output)
		<< self lineEnding;
		flush
]

{ #category : 'initialization' }
CommandLineDebugger >> process [

	^ process
]

{ #category : 'initialization' }
CommandLineDebugger >> process: aProcess [

	process := aProcess
]

{ #category : 'execution' }
CommandLineDebugger >> readNextLine [
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
CommandLineDebugger >> run [
	"Start debug phase, starting a loop, waiting for user's commands"

	| input tempRes |
	self printOutput: '--------------- Debug phase started ---------------'.
	self printOutput: ' For help, type "help"'. 

	[ self isActive ] whileTrue: [
			self askTyping.
			input := self readNextLine.
			input := self handleHistory: input trim.
			tempRes := self parsesAndExecuteCommand: input.
			self printOutput: tempRes ]
]

{ #category : 'accessing' }
CommandLineDebugger >> session [

	^ session
]

{ #category : 'accessing' }
CommandLineDebugger >> session: anObject [

	session := anObject
]
