Class {
	#name : 'RunnerLongDurationTest',
	#superclass : 'TestCase',
	#instVars : [
		'runner'
	],
	#category : 'TestRunner-Tests-Core',
	#package : 'TestRunner-Tests',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
RunnerLongDurationTest >> longTestClass [

	^ LongTest
]

{ #category : 'running' }
RunnerLongDurationTest >> setUp [

	super setUp.
	self longTestClass doNotIgnoreTest .
	runner := NewTestRunner new suitePreparator:
		          SuitePreparator withShuffling 
]

{ #category : 'tests' }
RunnerLongDurationTest >> testRunningFromAClass [

	runner runClass: self longTestClass.
	self assert: runner runCount equals: 1.
	self assert: runner passedCount equals: 1
]

{ #category : 'tests' }
RunnerLongDurationTest >> testRunningFromACollectionOfClasses [

	runner runClasses: { LongTest . LongTest . LongTest }.
	self assert: runner runCount equals: 3.
	self assert: runner passedCount equals: 3
]
