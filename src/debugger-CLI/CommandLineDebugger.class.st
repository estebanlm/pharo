"
A class to execute commands from command Line.
We can parse commands and arguments, and execute the dedicated method
"
Class {
	#name : 'CommandLineDebugger',
	#superclass : 'Object',
	#instVars : [
		'isActive'
	],
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'execution' }
CommandLineDebugger >> executeCommand: aString [
	"Parses a string to change it into an executable command and executes it"

	| subString command arguments |
	subString := aString trim substrings.
	subString ifEmpty: [ ^ '' ].

	command := subString first.

	arguments := subString allButFirst joinUsing: ' '.

	command = 'exit' ifTrue: [ ^ self executeExit ].
	command = 'print' ifTrue: [ ^ self executePrint: arguments ].
	command = 'step' ifTrue: [ ^ self executeStep ].

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

	evaluation := OpalCompiler new evaluate: anExpression.

	^ anExpression , ' : ' , evaluation asString
]

{ #category : 'execution' }
CommandLineDebugger >> executeStep [

	^ self
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
