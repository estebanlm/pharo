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
		'lineEnding'
	],
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'initialization' }
CommandLineDebugger >> completeStep [

	| callee |
	process suspendedContext == context ifFalse: [ ^ process complete: (process calleeOf: context) ].
	callee := process step.
	callee == context ifTrue: [ ^ callee ].
	context isDead ifTrue: [ ^ process suspendedContext ].
	^ process complete: callee "finish send"
]

{ #category : 'initialization' }
CommandLineDebugger >> context [

	^ context
]

{ #category : 'initialization' }
CommandLineDebugger >> context: aDebugContext [
    context := aDebugContext
]

{ #category : 'execution' }
CommandLineDebugger >> executeCommand: aCommand arg: arguments [
	"executes the command with potential arguments"

	aCommand = 'help' ifTrue: [ ^ self printHelp ].
	aCommand = 'exit' ifTrue: [ ^ self exit ].
	aCommand = 'print' ifTrue: [ ^ self print: arguments asString ].
	(aCommand = 'step' or: aCommand = 's') ifTrue: [ ^ self step ].
	(aCommand = 'over' or: aCommand = 'o') ifTrue: [ ^ self over ].
	(aCommand = 'printStack' or: aCommand = 'ps') ifTrue: [ ^ self printStack ].
	(aCommand = 'printCode' or: aCommand = 'pc') ifTrue: [ ^ self printCode ].

	^ self unknownCommand: aCommand
]

{ #category : 'execution' }
CommandLineDebugger >> exit [

	isActive := false.
	^ 'Bye!' 
]

{ #category : 'execution' }
CommandLineDebugger >> finishedDebugging [

	isActive := false.
	^ 'Execution finished. The program has ended.'
]

{ #category : 'initialization' }
CommandLineDebugger >> initialize [

	super initialize.
	isActive := true.
	lineEnding := OSPlatform current lineEnding
]

{ #category : 'initialization' }
CommandLineDebugger >> isActive [
    ^ isActive
]

{ #category : 'execution' }
CommandLineDebugger >> over [

	[ self completeStep ]
		on: Error
		do: [ :ex |
				(ex value asString includesSubstring: 'computation has been terminated') ifTrue: [ ^ self finishedDebugging ].
				ex pass ].

	context := process suspendedContext.

	context ifNil: [ ^ self finishedDebugging ].

	^ 'Stepped OVER to: ' , context printString , ' (PC: ' , context pc asString , ')'
]

{ #category : 'execution' }
CommandLineDebugger >> parsesAndExecuteCommand: aString [
	"Parses a string to change it into an executable command and executes it"

	| subString command arguments |
	subString := aString trim substrings.
	subString ifEmpty: [ ^ '' ].

	command := subString first.

	arguments := subString allButFirst joinUsing: ' '.
	self skipInternalContexts.

	^ self executeCommand: command arg: arguments
]

{ #category : 'execution' }
CommandLineDebugger >> print: aVariable [

	| evaluation |
	aVariable trim ifEmpty: [ ^ 'Nothing to print' ].
	[
		evaluation := context tempNamed: aVariable.
		^ aVariable , ' : ' , evaluation asString ]
		on: Error
		do: [ :ex | ^ 'Error evaluating: ' , aVariable ]
]

{ #category : 'execution' }
CommandLineDebugger >> printCode [

	| currentMethod codeOfCurrentMethod identedCode |
	currentMethod := context method.
	codeOfCurrentMethod := currentMethod sourceCode asString.


	identedCode := (codeOfCurrentMethod lines collect: [ :eachLine | String tab , eachLine ]) joinUsing: lineEnding .

	^ '====== Code of ' , currentMethod printString , ' ======' , lineEnding , identedCode , lineEnding
]

{ #category : 'execution' }
CommandLineDebugger >> printHelp [

	^ '========== Available commands ==========
	  step (or s) : execute next step
	  over (or o) : execute step over
	  printStack (or ps) : print the current Stack
	  printCode (or pc) : print current''s method code
	  exit : kills the debugger
	  help : print this help'
]

{ #category : 'execution' }
CommandLineDebugger >> printStack [

	| results remainingStackText firstOfStack |
	results := context contextStack collect: [ :ctx | ctx asString ].

	firstOfStack := '------> ' , results first asString.
	remainingStackText := (results allButFirst collect: [ :res | String tab , res ]) joinUsing: lineEnding.
	^ '==================== Call Stack ====================' , lineEnding , firstOfStack , lineEnding , remainingStackText
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
CommandLineDebugger >> skipInternalContexts [
	"To skip the first lines of the debugger"

	[ context notNil and: [ #( DoIt newProcess ) includes: context method selector ] ] whileTrue: [ self step ]
]

{ #category : 'execution' }
CommandLineDebugger >> step [

	[ process step ]
		on: Error
		do: [ :ex |
				process isTerminated ifTrue: [ ^ self finishedDebugging ].
				ex pass ].
	context := process suspendedContext.

	context ifNil: [ ^ self finishedDebugging ].

	^ 'Stepped to: ' , context printString , '(PC: ' , context pc printString , ')'
]

{ #category : 'execution' }
CommandLineDebugger >> unknownCommand: aCommand [ 

	^ 'Unknown command: ', aCommand
]
