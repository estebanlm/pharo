Class {
	#name : 'PrintCodeCommand',
	#superclass : 'DebuggerCommand',
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'printing' }
PrintCodeCommand >> executeOn: aDebugger with: args [

	| codeOfCurrentMethod sne debugContext |
	debugContext := aDebugger context.
	codeOfCurrentMethod := debugContext method sourceCode asString.

	sne := debugContext sourceNodeExecuted.

	^ '{1}--->{2}<---{3}' format: {
			  (codeOfCurrentMethod copyFrom: 1 to: sne start - 1).
			  (codeOfCurrentMethod copyFrom: sne start to: sne stop).
			  (codeOfCurrentMethod copyFrom: sne stop + 1 to: codeOfCurrentMethod size) }
]

{ #category : 'initialization' }
PrintCodeCommand >> initialize [

	super initialize.
	self commandName: #( 'printCode' 'pc' ).
	self commandHelp: 'print current''method code'.
	self arguments: ''
]
