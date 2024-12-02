Class {
	#name : 'ReExtractTempDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'interval',
		'selector',
		'class',
		'uiManager'
	],
	#category : 'Refactoring-UI-Driver',
	#package : 'Refactoring-UI',
	#tag : 'Driver'
}

{ #category : 'execution' }
ReExtractTempDriver >> changes [ 

	^ refactoring privateTransform; changes
]

{ #category : 'resources' }
ReExtractTempDriver >> configureRefactoring [

	refactoring := RBExtractToTemporaryRefactoring
			extract: interval
			from: selector 
			in: class.
	refactoring prepareForExecution 
]

{ #category : 'instance creation' }
ReExtractTempDriver >> extract: anInterval from: aSelector in: aClass [

	interval := anInterval.
	selector := aSelector.
	class := aClass
]

{ #category : 'user requests' }
ReExtractTempDriver >> getVariableName: initialAnswer errorMessage: message [

	^ self uiManager
		request: 'New temp name: ' , message
		initialAnswer: initialAnswer
		title: 'Extract code to temp variable'
]

{ #category : 'execution' }
ReExtractTempDriver >> runRefactoring [ 

	| varName failed errorString |
	self configureRefactoring.
	varName := ''.
	failed := nil.
	[
		errorString := failed ifNil: [ '' ] ifNotNil: [ self failedPreconditionsErrorString: failed ].
		varName := self getVariableName: varName errorMessage: errorString.
		varName ifNil: [ ^ self ].
		refactoring variableName: varName.
		failed := refactoring failedApplicabilityPreconditions.
	] doWhileFalse: 
		[ varName isEmptyOrNil not and: [ failed isEmpty ] ].
	
	self applyChanges
]

{ #category : 'private' }
ReExtractTempDriver >> uiManager [

	^ uiManager ifNil: [ MorphicUIManager new ]
]

{ #category : 'private' }
ReExtractTempDriver >> uiManager: aManager [

	uiManager := aManager
]
