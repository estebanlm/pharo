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

{ #category : 'running' }
RunnerLongDurationTest >> setUp [

	super setUp.
	runner := NewTestRunner new suitePreparator:
		          SuitePreparator shuffleSuitePreparatorClass 
]

{ #category : 'tests' }
RunnerLongDurationTest >> testRunningFromACollectionOfPackages [

	"first execution"

	| packages |
	self skip: 'these tests depend on the duration of other tests, it would be better to create a mock test package'.
	packages := OrderedCollection
		            with: #'Zodiac-Tests' asPackage
		            with: #'Zodiac-Tests' asPackage.
	runner runPackages: packages.
	self assert: runner runCount equals: 79 * 2.
	self assert: runner passedCount equals: 79 * 2
]

{ #category : 'tests' }
RunnerLongDurationTest >> testRunningFromAPackage [

	"first execution"

	| aPackage |
	self skip: 'these tests depend on the duration of other tests, it would be better to create a mock test package'.
	aPackage := #'Zodiac-Tests' asPackage.
	runner runPackage: aPackage.
	self assert: runner runCount equals: 79.
	self assert: runner passedCount equals: 79
]
