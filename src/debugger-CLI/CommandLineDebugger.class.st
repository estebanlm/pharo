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
CommandLineDebugger >> executeCommand: command [
	^ command
]
