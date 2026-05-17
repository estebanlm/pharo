"
I check that the given selector have more that 1 sender
"
Class {
	#name : 'ReIsLastSenderCondition',
	#superclass : 'ReMethodsCondition',
	#instVars : [
		'selector',
		'model'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'accessing' }
ReIsLastSenderCondition >> selector: aSelector [

	selector := aSelector
]

{ #category : 'accessing' }
ReIsLastSenderCondition >> selector: aSelector model: aModel [

	selector := aSelector.
	model := aModel 
]

{ #category : 'displaying' }
ReIsLastSenderCondition >> violationMessageOn: aStream [

	self violators do: [ :each |
			aStream
			nextPutAll: 'This is the last sender of ';
				nextPutAll: each;
				nextPutAll: '. Consider removing the method.' ]
]

{ #category : 'accessing' }
ReIsLastSenderCondition >> violators [

	violators ifNotNil: [ ^ violators ].
	violators := OrderedCollection new.

	(model allReferencesTo: selector) size <= 1 ifTrue: [ violators add: selector ].

	^ violators
]
