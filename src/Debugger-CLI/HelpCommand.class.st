Class {
	#name : 'HelpCommand',
	#superclass : 'DebuggerCommand',
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
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
