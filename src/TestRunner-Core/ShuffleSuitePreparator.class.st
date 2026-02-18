Class {
	#name : 'ShuffleSuitePreparator',
	#superclass : 'SuitePreparator',
	#instVars : [
		'randomGenerator'
	],
	#category : 'TestRunner-Core-SuitePreparators',
	#package : 'TestRunner-Core',
	#tag : 'SuitePreparators'
}

{ #category : 'applying' }
ShuffleSuitePreparator >> applyOn: aSuite [

	aSuite tests shuffleBy: self randomGenerator copy
]

{ #category : 'accessing' }
ShuffleSuitePreparator >> randomGenerator [ 

	^ randomGenerator ifNil: [ randomGenerator := Random new ]
]

{ #category : 'accessing' }
ShuffleSuitePreparator >> randomGenerator: anObject [

	randomGenerator := anObject
]
