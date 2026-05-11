Class {
	#name : 'PrintCodeCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
PrintCodeCommand >> executeOn: aDebugger with: arguments [

	| currentMethod codeOfCurrentMethod identedCode |
	currentMethod := aDebugger context method.
	codeOfCurrentMethod := currentMethod sourceCode asString.


	identedCode := (codeOfCurrentMethod lines collect: [ :eachLine | String tab , eachLine ]) joinUsing: aDebugger lineEnding.

	^ '====== Code of ' , currentMethod printString , ' ======' , aDebugger lineEnding , identedCode , aDebugger lineEnding
]

{ #category : 'initialization' }
PrintCodeCommand >> initialize [

	super initialize.
	self commandName: #( 'printCode' 'pc' ).
	self commandHelp: 'print current''method code'
]
