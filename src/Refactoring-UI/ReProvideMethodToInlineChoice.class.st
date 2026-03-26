Class {
	#name : 'ReProvideMethodToInlineChoice',
	#superclass : 'ReMethodChoice',
	#category : 'Refactoring-UI-Choices',
	#package : 'Refactoring-UI',
	#tag : 'Choices'
}

{ #category : 'accessing' }
ReProvideMethodToInlineChoice >> action [

	driver selectMethodToInline
]

{ #category : 'accessing' }
ReProvideMethodToInlineChoice >> description [

	^ 'Select the method to be inlined'
]
