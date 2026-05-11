Class {
	#name : 'DebuggerCommand',
	#superclass : 'Object',
	#instVars : [
		'commandName',
		'commandHelp'
	],
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'accessing' }
DebuggerCommand >> commandHelp [

	^ commandHelp
]

{ #category : 'accessing' }
DebuggerCommand >> commandHelp: anObject [

	commandHelp := anObject
]

{ #category : 'accessing' }
DebuggerCommand >> commandName [

	^ commandName
]

{ #category : 'accessing' }
DebuggerCommand >> commandName: anObject [

	commandName := anObject
]

{ #category : 'printing' }
DebuggerCommand >> executeOn: aDebugger with: arguments [

	^ self
]

{ #category : 'printing' }
DebuggerCommand >> printHelp [

	^ '{1} ( or ''{2}'') : {3}' format: {
			  (commandName first).
			  (commandName last).
			  commandHelp }
]
