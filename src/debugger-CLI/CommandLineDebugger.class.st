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

	command = 'exit' ifTrue: [ ^ self executeExit ]. "command = 'print' ifTrue: [ ^ self executePrint: arguments asString ]."
	(command = 'step' or: command = 's') ifTrue: [ ^ self executeStepInto ].
	(command = 'printStack' or: command = 'ps') ifTrue: [ ^ self executePrintStack ].

	^ self executeUnknownCommand: command
]

{ #category : 'execution' }
CommandLineDebugger >> executeExit [

	isActive := false.
	^ 'Bye!' 
]

{ #category : 'execution' }
CommandLineDebugger >> executePrint: anExpression [

	| evaluation |
	anExpression trim ifEmpty: [ ^ 'Nothing to print' ].

	"[ evaluation := context evaluate: anExpression ]
		on: Error
		do: [ :ex | ^ 'Error evaluating: ' , anExpression ]."

	^ anExpression , ' : ' , evaluation asString
]

{ #category : 'execution' }
CommandLineDebugger >> executePrintStack [

	| results remainingStackText firstOfStack |
	results := context contextStack collect: [ :ctx | ctx asString ].

	firstOfStack := '------> ' , results first asString.
	remainingStackText := (results allButFirst collect: [ :res | String tab , res ]) joinUsing: Character lf.
	^ '==================== Call Stack ====================' , String lf , firstOfStack , String lf , remainingStackText
]

{ #category : 'execution' }
CommandLineDebugger >> executeStepInto [

	process step.

	context := process suspendedContext.
	^ 'Stepped to: ' , context printString , '(PC: ' , context pc printString , ')'
]

{ #category : 'execution' }
CommandLineDebugger >> executeUnknownCommand: aCommand [ 

	^ 'Unknown command: ', aCommand
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

{ #category : 'initialization' }
CommandLineDebugger >> process [

	^ process
]

{ #category : 'initialization' }
CommandLineDebugger >> process: aProcess [

	process := aProcess
]
