Class {
	#name : 'ExitCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'initialization' }
ExitCommand >> executeOn: aDebugger with: arguments [

	aDebugger disActivate.
	^ 'Bye!'
]

{ #category : 'initialization' }
ExitCommand >> initialize [

	super initialize.
	self commandName: #( 'quit' 'q' ).
	self commandHelp: 'kills the debugger'
]
