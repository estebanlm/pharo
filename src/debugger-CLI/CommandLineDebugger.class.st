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
	command = 'exit' ifTrue: [ ^ self executeExit ].

	arguments := subString allButFirst joinUsing: ' '. "arguments de la commande pour le print ou autre plus tard"

	^ self executeUnknownCommand: command
]

{ #category : 'execution' }
CommandLineDebugger >> executeExit [

	isActive := false.
	^ 'Bye!' 
]

{ #category : 'execution' }
CommandLineDebugger >> executePrint: anExpression [

	^ self
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
