Class {
	#name : 'UnknownCommand',
	#superclass : 'DebuggerCommand',
	#instVars : [
		'command'
	],
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'accessing' }
UnknownCommand >> command [

	^ command
]

{ #category : 'accessing' }
UnknownCommand >> command: anObject [

	command := anObject
]

{ #category : 'printing' }
UnknownCommand >> executeOn: aDebugger with: args [

	^ 'Unknown command: ' , command
]

{ #category : 'initialization' }
UnknownCommand >> initialize [

	super initialize.
	self commandName: #( 'any other command' 'anUnknownCommand' ).
	self commandHelp: 'Unknown command'.
	self arguments: ''
]
