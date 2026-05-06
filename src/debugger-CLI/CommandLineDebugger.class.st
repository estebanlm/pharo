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

{ #category : 'execution' }
CommandLineDebugger >> Exit [

	isActive := false.
	^ 'Bye!' 
]

{ #category : 'execution' }
CommandLineDebugger >> Over [

	[ process completeStep: context ]
		on: Error
		do: [ :ex |
				process isTerminated ifTrue: [ ^ self finishedDebugging ].
				ex pass ].

	context := process suspendedContext.
	context ifNil: [ ^ self finishedDebugging ].

	^ 'Stepped OVER to: ' , context printString , ' (PC: ' , context pc asString , ')'
]

{ #category : 'execution' }
CommandLineDebugger >> Print: anExpression [

	| evaluation |
	anExpression trim ifEmpty: [ ^ 'Nothing to print' ].

	"[ evaluation := context evaluate: anExpression ]
		on: Error
		do: [ :ex | ^ 'Error evaluating: ' , anExpression ]."

	^ anExpression , ' : ' , evaluation asString
]

{ #category : 'execution' }
CommandLineDebugger >> PrintCode [

	| currentMethod codeOfCurrentMethod identedCode |
	currentMethod := context method.
	codeOfCurrentMethod := currentMethod sourceCode asString.

	identedCode := (codeOfCurrentMethod lines collect: [ :eachLine | String tab , eachLine ]) joinUsing: String lf.

	^ '====== Code of ' , currentMethod printString , ' ======' , String lf , identedCode , String lf
]

{ #category : 'execution' }
CommandLineDebugger >> PrintStack [

	| results remainingStackText firstOfStack |
	results := context contextStack collect: [ :ctx | ctx asString ].

	firstOfStack := '------> ' , results first asString.
	remainingStackText := (results allButFirst collect: [ :res | String tab , res ]) joinUsing: Character lf.
	^ '==================== Call Stack ====================' , String lf , firstOfStack , String lf , remainingStackText
]

{ #category : 'execution' }
CommandLineDebugger >> Step [

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
CommandLineDebugger >> UnknownCommand: aCommand [ 

	^ 'Unknown command: ', aCommand
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

	command = 'help' ifTrue: [ ^ self printHelp ].
	command = 'exit' ifTrue: [ ^ self Exit ]. "command = 'print' ifTrue: [ ^ self executePrint: arguments asString ]."
	(command = 'step' or: command = 's') ifTrue: [ ^ self Step ].
	(command = 'over' or: command = 'o') ifTrue: [ ^ self Over ].
	(command = 'printStack' or: command = 'ps') ifTrue: [ ^ self PrintStack ].
	(command = 'printCode' or: command = 'pc') ifTrue: [ ^ self PrintCode ].

	^ self UnknownCommand: command
]

{ #category : 'execution' }
CommandLineDebugger >> executePrintCode [
    ^ context method sourceCode asString
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
CommandLineDebugger >> printHelp [

	^ '========== Available commands ==========
	  step (or s) : execute next step
	  over (or o) : execute step over
	  printStack (or ps) : print the current Stack
	  printCode (or pc) : print current''s method code
	  exit : kills the debugger'
	
]

{ #category : 'initialization' }
CommandLineDebugger >> process [

	^ process
]

{ #category : 'initialization' }
CommandLineDebugger >> process: aProcess [

	process := aProcess
]
