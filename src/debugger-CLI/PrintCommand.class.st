Class {
	#name : 'PrintCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
PrintCommand >> executeOn: aDebugger with: arguments [

	| evaluation |
	arguments trim ifEmpty: [ ^ 'Nothing to print' ].
	[
		evaluation := aDebugger context tempNamed: arguments.
		^ arguments , ' : ' , evaluation asString ]
		on: Error
		do: [ :ex | ^ 'Error evaluating: ' , arguments ]
]

{ #category : 'initialization' }
PrintCommand >> initialize [

	super initialize.
	self commandName: #( 'print' 'p' ).
	self commandHelp: 'evaluate the given expression'
]

{ #category : 'printing' }
PrintCommand >> printHelp [

	^ '{1} ( or ''{2}'') <exression> : {3}' format: {
			  (commandName first).
			  (commandName last).
			  commandHelp }
]
