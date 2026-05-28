Class {
	#name : 'DebuggerCommand',
	#superclass : 'Object',
	#instVars : [
		'commandName',
		'commandHelp',
		'arguments'
	],
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'accessing' }
DebuggerCommand >> arguments [

	^ arguments
]

{ #category : 'accessing' }
DebuggerCommand >> arguments: anObject [

	arguments := anObject
]

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

{ #category : 'execution' }
DebuggerCommand >> executeOn: aDebugger with: args [ 
	^ self subclassResponsibility
]

{ #category : 'printing' }
DebuggerCommand >> printHelp [

	^ '{1} ( or ''{2}'') {3} : {4}' format: {
			  (commandName first).
			  (commandName last).
			  (arguments).
			  commandHelp }
]
