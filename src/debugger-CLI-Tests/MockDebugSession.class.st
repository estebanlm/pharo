Class {
	#name : 'MockDebugSession',
	#superclass : 'Object',
	#instVars : [
		'didStepInto',
		'didStepOver'
	],
	#category : 'debugger-CLI-Tests',
	#package : 'debugger-CLI-Tests'
}

{ #category : 'initialization' }
MockDebugSession >> evaluate: anExpression [
   
    ^ Smalltalk compiler evaluate: anExpression
]

{ #category : 'initialization' }
MockDebugSession >> hasSteppedInto [

	^ didStepInto
]

{ #category : 'initialization' }
MockDebugSession >> hasSteppedOver [

	^ didStepOver
]

{ #category : 'initialization' }
MockDebugSession >> initialize [

	super initialize.
	didStepInto := false.
	didStepOver := false
]

{ #category : 'initialization' }
MockDebugSession >> stepInto [

	didStepInto := true
]

{ #category : 'initialization' }
MockDebugSession >> stepOver [

	didStepOver := true
]
