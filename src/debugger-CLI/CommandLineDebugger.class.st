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
		'process'
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
CommandLineDebugger >> executeCommand: aString [
	"Parses a string to change it into an executable command and executes it"

	| subString command arguments |
	subString := aString trim substrings.
	subString ifEmpty: [ ^ '' ].

	command := subString first.

	arguments := subString allButFirst joinUsing: ' '.

	[ context notNil and: [ #( DoIt newProcess ) includes: context method selector ] ] whileTrue: [ self step ]. "To skip the first lines"

	command = 'help' ifTrue: [ ^ self printHelp ].
	command = 'exit' ifTrue: [ ^ self exit ].
	command = 'print' ifTrue: [ ^ self print: arguments asString ].
	(command = 'step' or: command = 's') ifTrue: [ ^ self step ].
	(command = 'over' or: command = 'o') ifTrue: [ ^ self over ].
	(command = 'printStack' or: command = 'ps') ifTrue: [ ^ self printStack ].
	(command = 'printCode' or: command = 'pc') ifTrue: [ ^ self printCode ].

	^ self unknownCommand: command
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
				process isTerminated ifTrue: [ ^ self finishedDebugging ].
				ex pass ].

	context := process suspendedContext.
	context ifNil: [ ^ self finishedDebugging ].

	^ 'Stepped OVER to: ' , context printString , ' (PC: ' , context pc asString , ')'
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

	identedCode := (codeOfCurrentMethod lines collect: [ :eachLine | String tab , eachLine ]) joinUsing: String lf.

	^ '====== Code of ' , currentMethod printString , ' ======' , String lf , identedCode , String lf
]

{ #category : 'execution' }
CommandLineDebugger >> printHelp [

	^ '========== Available commands ==========
	  step (or s) : execute next step
	  over (or o) : execute step over
	  printStack (or ps) : print the current Stack
	  printCode (or pc) : print current''s method code
	  exit : kills the debugger'
	
]

{ #category : 'execution' }
CommandLineDebugger >> printStack [

	| results remainingStackText firstOfStack |
	results := context contextStack collect: [ :ctx | ctx asString ].

	firstOfStack := '------> ' , results first asString.
	remainingStackText := (results allButFirst collect: [ :res | String tab , res ]) joinUsing: Character lf.
	^ '==================== Call Stack ====================' , String lf , firstOfStack , String lf , remainingStackText
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
