Class {
	#name : 'AnyEffectSuitePreparatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'runner'
	],
	#category : 'TestRunner-Tests-Preparators',
	#package : 'TestRunner-Tests',
	#tag : 'Preparators'
}

{ #category : 'tests' }
AnyEffectSuitePreparatorTest >> testSuitePreparator [
	
	|initialSuite initialSuiteCopy|
	initialSuite := GreenTest suite.
	initialSuiteCopy := initialSuite copy.
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
	
	SuitePreparator anySuitePreparatorClass applyOn: initialSuite.
	
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
]
