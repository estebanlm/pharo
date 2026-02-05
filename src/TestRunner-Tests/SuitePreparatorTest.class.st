Class {
	#name : 'SuitePreparatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'runner'
	],
	#category : 'TestRunner-Tests-Preparators',
	#package : 'TestRunner-Tests',
	#tag : 'Preparators'
}

{ #category : 'tests' }
SuitePreparatorTest >> testSuitePreparator [
	
	|initialSuite initialSuiteCopy|
	initialSuite := GreenTest suite.
	initialSuiteCopy := initialSuite copy.
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
	
	SuitePreparator new applyOn: initialSuite.
	
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
]
