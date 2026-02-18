"
A ShuffleSuitePreparatorTest is a test class for testing the behavior of ShuffleSuitePreparator
"
Class {
	#name : 'ShuffleSuitePreparatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'preparator',
		'randomGenerator',
		'suite'
	],
	#category : 'TestRunner-Tests-Preparators',
	#package : 'TestRunner-Tests',
	#tag : 'Preparators'
}

{ #category : 'asserting' }
ShuffleSuitePreparatorTest >> assertSuiteSelectorsEquals: aCollection [

	^ self 
		assertCollection: (self suite tests collect: #selector) 
		equals: aCollection asOrderedCollection 
]

{ #category : 'accessing' }
ShuffleSuitePreparatorTest >> preparator [

	^ preparator ifNil: [ preparator := ShuffleSuitePreparator new 
		randomGenerator: self randomGenerator; yourself. ]
]

{ #category : 'accessing' }
ShuffleSuitePreparatorTest >> randomGenerator [ 

	^ randomGenerator ifNil: [ randomGenerator := Random seed: 4 ]
]

{ #category : 'accessing' }
ShuffleSuitePreparatorTest >> suite [

	^ suite ifNil: [ suite := AllTestFailTest suite ]
]

{ #category : 'tests' }
ShuffleSuitePreparatorTest >> testIsSuiteShuffled [

	self assertSuiteSelectorsEquals: { #testFail1 . #testFail2 . #testFail3 . #testFail4 }.
		
	self preparator applyOn: self suite.
	
	self assertSuiteSelectorsEquals: { #testFail3 . #testFail4 . #testFail2 . #testFail1 }.
]
