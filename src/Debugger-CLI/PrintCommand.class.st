Class {
	#name : 'PrintCommand',
	#superclass : 'DebuggerCommand',
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'printing' }
PrintCommand >> executeOn: aDebugger with: args [

	| evaluation |
	args trim ifEmpty: [ ^ 'Nothing to print' ].
	[
		evaluation := OpalEvaluator new
			              context: aDebugger context;
			              evaluate: args.
		^ args , ' : ' , evaluation asString ]
		on: Error
		do: [ :ex | ^ 'Error evaluating: ' , args ]
]

{ #category : 'initialization' }
PrintCommand >> initialize [

	super initialize.
	self commandName: #( 'print' 'p' ).
	self commandHelp: 'evaluate the expression'.
	self arguments: '<expression>'
]
