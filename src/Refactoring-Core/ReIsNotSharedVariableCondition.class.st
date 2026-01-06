Class {
	#name : 'ReIsNotSharedVariableCondition',
	#superclass : 'ReVariableNameCondition',
	#instVars : [
		'model'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'instance creation' }
ReIsNotSharedVariableCondition class >> name: aName model: aModel [

	^ (self name: aName)
		model: aModel;
		yourself
]

{ #category : 'checking' }
ReIsNotSharedVariableCondition >> check [

	model allClassesDo: [ :cls |
		(cls directlyDefinesClassVariable: name) ifTrue: [ violator := cls name ] ].
	^ violator isNil
]

{ #category : 'accessing' }
ReIsNotSharedVariableCondition >> model: aModel [

	model := aModel
]

{ #category : 'displaying' }
ReIsNotSharedVariableCondition >> violationMessageOn: aStream [

	aStream nextPutAll: name;
		nextPutAll: ' already exists as a shared variable in ';
		nextPutAll: violator
]
