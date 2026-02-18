"
I define a suite preparator that stores a seed before shuffling tests
"
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

	aSuite tests shuffleBy: self randomGenerator 
]

{ #category : 'accessing' }
ShuffleSuitePreparator >> randomGenerator [ 

	^ randomGenerator ifNil: [ randomGenerator := Random new ]
]

{ #category : 'accessing' }
ShuffleSuitePreparator >> randomGenerator: anObject [

	randomGenerator := anObject
]
