Class {
	#name : 'ReNoSelfSendMessagesCondition',
	#superclass : 'ReMethodsCondition',
	#instVars : [
		'sourceMessage'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'accessing' }
ReNoSelfSendMessagesCondition >> sourceMessage: aMessage [

	sourceMessage := aMessage
]

{ #category : 'displaying' }
ReNoSelfSendMessagesCondition >> violationMessageOn: aStream [

	aStream nextPutAll: 'Cannot inline non-self messages'
]

{ #category : 'accessing' }
ReNoSelfSendMessagesCondition >> violators [

	violators ifNotNil: [ ^ violators ].
	violators := OrderedCollection new.
	(sourceMessage receiver isSelfVariable or: [ sourceMessage receiver isSuperVariable ]) ifFalse: [ violators add: sourceMessage ].
	^ violators
]
