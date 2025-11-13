Class {
	#name : 'ReClassToConvertTemporaryToInstanceVariable',
	#superclass : 'Object',
	#instVars : [
		'instVar'
	],
	#category : 'Refactoring-DataForTesting-ForConvertingVariables',
	#package : 'Refactoring-DataForTesting',
	#tag : 'ForConvertingVariables'
}

{ #category : 'action' }
ReClassToConvertTemporaryToInstanceVariable >> doAction1 [

	| temp |
	temp := 35.

	^ temp
]

{ #category : 'action' }
ReClassToConvertTemporaryToInstanceVariable >> doAction2 [

	| instVar |
	instVar := 3.
	^ instVar
]
