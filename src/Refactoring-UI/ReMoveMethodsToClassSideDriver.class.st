"
I'm a model for user interaction for the rename method refactoring.
"
Class {
	#name : 'ReMoveMethodsToClassSideDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'class',
		'originalMessage',
		'newMessage',
		'shouldEscape',
		'methodNameEditorPresenterClass'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'initialization' }
ReMoveMethodsToClassSideDriver class >> scopes: scopesList methods: aCollectionOfMethods [

	^ self new scopes: scopesList methods: aCollectionOfMethods
]
