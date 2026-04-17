"
I handle user interaction when invoking Inline All Senders Refactoring
"
Class {
	#name : 'ReInlineAllSendersDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'class',
		'message'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'accessing' }
ReInlineAllSendersDriver class >> driverName [

	^ 'Inline All Senders'
]

{ #category : 'configuration' }
ReInlineAllSendersDriver >> instantiateRefactoring [

	^ ReInlineAllSendersRefactoring model: model sendersOf: message in: class
]

{ #category : 'instance creation' }
ReInlineAllSendersDriver >> scopes: refactoringScopes message: originalMessage class: methodOrigin [

	scopes := refactoringScopes.
	model := self refactoringScopeOn: scopes first.
	message := originalMessage.
	class := methodOrigin
]
