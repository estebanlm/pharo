Class {
	#name : 'PrintStackCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
PrintStackCommand >> executeOn: aDebugger with: arguments [

	| results remainingStackText firstOfStack |
	results := aDebugger context contextStack collect: [ :ctx | ctx asString ].

	firstOfStack := '------> ' , results first asString.
	remainingStackText := (results allButFirst collect: [ :res | String tab , res ]) joinUsing: aDebugger lineEnding.
	^ '==================== Call Stack ====================' , aDebugger lineEnding , firstOfStack , aDebugger lineEnding
	  , remainingStackText
]

{ #category : 'initialization' }
PrintStackCommand >> initialize [

	super initialize.
	self commandName: #( 'printStack' 'ps' ).
	self commandHelp: 'print the current Stack'
]
