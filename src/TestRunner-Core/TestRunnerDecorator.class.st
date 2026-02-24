"
I am an abstract decorator for a `NewTestRunner`
"
Class {
	#name : 'TestRunnerDecorator',
	#superclass : 'Object',
	#instVars : [
		'testRunner'
	],
	#category : 'TestRunner-Core-Decorators',
	#package : 'TestRunner-Core',
	#tag : 'Decorators'
}

{ #category : 'accessing' }
TestRunnerDecorator class >> runner: aTestRunner [

	^ self new testRunner: aTestRunner; yourself
]

{ #category : 'asserting' }
TestRunnerDecorator >> classForTestResult [ 
		
	^ self testRunner classForTestResult
]

{ #category : 'running' }
TestRunnerDecorator >> debugFailure: failure [

	self testRunner debugFailure: failure 
]

{ #category : 'API' }
TestRunnerDecorator >> doNotAccumulateResult [

	self testRunner doNotAccumulateResult 
]

{ #category : 'API' }
TestRunnerDecorator >> errorCount [

	^ self testRunner errorCount 
]

{ #category : 'API' }
TestRunnerDecorator >> executionMode [

	^ self testRunner executionMode 
]

{ #category : 'API' }
TestRunnerDecorator >> executionMode: anObject [

	^ self testRunner executionMode: anObject 
]

{ #category : 'API' }
TestRunnerDecorator >> executionModeClass [

	^ self testRunner executionModeClass
]

{ #category : 'API' }
TestRunnerDecorator >> failureCount [

	^ self testRunner failureCount
]

{ #category : 'API' }
TestRunnerDecorator >> hasTestsToRun [

	^ self testRunner hasTestsToRun
]

{ #category : 'API' }
TestRunnerDecorator >> passedCount [

	^ self testRunner passedCount
]

{ #category : 'API' }
TestRunnerDecorator >> prepareSuite [

	^ self testRunner prepareSuite
]

{ #category : 'API' }
TestRunnerDecorator >> resetResult [

	^ self testRunner resetResult
]

{ #category : 'API' }
TestRunnerDecorator >> resetSuite [

	^ self testRunner resetSuite
]

{ #category : 'API' }
TestRunnerDecorator >> result [

	^ self testRunner result
]

{ #category : 'API' }
TestRunnerDecorator >> resultDescription [

	^ self testRunner resultDescription
]

{ #category : 'API' }
TestRunnerDecorator >> run: aRunnable [

	^ self testRunner run: aRunnable
]

{ #category : 'API' }
TestRunnerDecorator >> runAll [

	^ self testRunner runAll
]

{ #category : 'API' }
TestRunnerDecorator >> runCase: aTestCase [

	^ self testRunner runCase: aTestCase
]

{ #category : 'API' }
TestRunnerDecorator >> runClass: aClass [

	^ self testRunner runClass: aClass
]

{ #category : 'API' }
TestRunnerDecorator >> runClasses: aCollectionOfTestCases [

	^ self testRunner runClasses: aCollectionOfTestCases
]

{ #category : 'API' }
TestRunnerDecorator >> runCount [

	^ self testRunner runCount
]

{ #category : 'API' }
TestRunnerDecorator >> runError: aTestCase [

	^ self testRunner runError: aTestCase
]

{ #category : 'API' }
TestRunnerDecorator >> runErrors [

	^ self testRunner runErrors
]

{ #category : 'API' }
TestRunnerDecorator >> runFailure: aTestCase [

	^ self testRunner runFailure: aTestCase
]

{ #category : 'API' }
TestRunnerDecorator >> runFailures [

	^ self testRunner runFailures
]

{ #category : 'API' }
TestRunnerDecorator >> runPackage: aPackage [

	^ self testRunner runPackage: aPackage
]

{ #category : 'API' }
TestRunnerDecorator >> runPackages: aCollection [

	^ self testRunner runPackages: aCollection
]

{ #category : 'API' }
TestRunnerDecorator >> runSequenceableCollection: aCollection [

	^ self testRunner runSequenceableCollection: aCollection
]

{ #category : 'API' }
TestRunnerDecorator >> runSuite [

	^ self testRunner runSuite
]

{ #category : 'API' }
TestRunnerDecorator >> runSuite: aTestSuite [

	^ self testRunner runSuite: aTestSuite
]

{ #category : 'API' }
TestRunnerDecorator >> shouldAccumulate [

	^ self testRunner shouldAccumulate
]

{ #category : 'API' }
TestRunnerDecorator >> shouldAccumulate: aBoolean [

	^ self testRunner shouldAccumulate: aBoolean
]

{ #category : 'API' }
TestRunnerDecorator >> someTestCausesError [

	^ self testRunner someTestCausesError
]

{ #category : 'API' }
TestRunnerDecorator >> someTestFailed [

	^ self testRunner someTestFailed
]

{ #category : 'API' }
TestRunnerDecorator >> suite [

	^ self testRunner suite
]

{ #category : 'API' }
TestRunnerDecorator >> suite: aTestSuite [

	^ self testRunner suite: aTestSuite
]

{ #category : 'API' }
TestRunnerDecorator >> suitePreparator [

	^ self testRunner suitePreparator
]

{ #category : 'API' }
TestRunnerDecorator >> suitePreparator: aSuitePreparator [

	^ self testRunner suitePreparator: aSuitePreparator
]

{ #category : 'API' }
TestRunnerDecorator >> suitePreparatorClass [

	^ self testRunner suitePreparatorClass
]

{ #category : 'API' }
TestRunnerDecorator >> switchToDebugMode [

	^ self testRunner switchToDebugMode
]

{ #category : 'API' }
TestRunnerDecorator >> switchToRunMode [

	^ self testRunner switchToRunMode
]

{ #category : 'API' }
TestRunnerDecorator >> tearDown [

	^ self testRunner tearDown
]

{ #category : 'accessing' }
TestRunnerDecorator >> testRunner [

	^ testRunner
]

{ #category : 'accessing' }
TestRunnerDecorator >> testRunner: anObject [

	testRunner := anObject
]

{ #category : 'API' }
TestRunnerDecorator >> testSuiteFromClass: aClass [

	^ self testRunner testSuiteFromClass: aClass
]

{ #category : 'API' }
TestRunnerDecorator >> testSuiteFromPackage: aPackage [

	^ self testRunner testSuiteFromPackage: aPackage
]

{ #category : 'API' }
TestRunnerDecorator >> testSuitesFromClasses: aCollectionOfClass [

	^ self testRunner testSuitesFromClasses: aCollectionOfClass
]

{ #category : 'API' }
TestRunnerDecorator >> testsCount [

	^ self testRunner testsCount
]

{ #category : 'API' }
TestRunnerDecorator >> updateResultWith: testResult [

	^ self testRunner updateResultWith: testResult
]
