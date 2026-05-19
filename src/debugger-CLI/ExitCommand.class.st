Class {
	#name : 'ExitCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'initialization' }
ExitCommand >> executeOn: aDebugger with: args [

	aDebugger disActivate.
	^ 'Debugging finished'
]

{ #category : 'initialization' }
ExitCommand >> initialize [

	super initialize.
	self commandName: #( 'quit' 'q' ).
	self commandHelp: 'kills the debugger'.
	self arguments: ''
]
