Class {
	#name : 'HelpCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
HelpCommand >> executeOn: aDebugger with: args [

	| helpArray informLine |
	helpArray := aDebugger commands values collect: [ :command | String tab , command printHelp ].
	informLine := '=========== available commands ==========='.

	^ informLine , aDebugger lineEnding , (helpArray asSet asArray joinUsing: aDebugger lineEnding)
]

{ #category : 'initialization' }
HelpCommand >> initialize [

	super initialize.
	self commandName: #( 'help' 'h' ).
	self commandHelp: 'print this help'.
	self arguments: ''
]
