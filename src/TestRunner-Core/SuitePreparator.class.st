"
I define a strategy for `NewTestRunner` to prepare a test suite before execution.

We would like to apply processes like randomisation or proxies to tests and suites, hence `SuitePreparator>>#applyOn:` is sent after building a TestSuite and before executing its tests.
"
Class {
	#name : 'SuitePreparator',
	#superclass : 'Object',
	#instVars : [
		'applyBlock'
	],
	#category : 'TestRunner-Core-SuitePreparators',
	#package : 'TestRunner-Core',
	#tag : 'SuitePreparators'
}

{ #category : 'factory' }
SuitePreparator class >> applyBlock: aBlock [

	^ self new
		applyBlock: aBlock;
		yourself
]

{ #category : 'factory' }
SuitePreparator class >> withShuffling [

	^ self applyBlock: [ :testSuite | testSuite tests shuffle ]
]

{ #category : 'accessing' }
SuitePreparator >> applyBlock [

	^ applyBlock ifNil: [ [  ] ]
]

{ #category : 'accessing' }
SuitePreparator >> applyBlock: anObject [

	applyBlock := anObject
]

{ #category : 'applying' }
SuitePreparator >> applyOn: testSuite [
	"this method defined the process which will applied in a giving suite."

	self applyBlock cull: testSuite 
]

{ #category : 'applying' }
SuitePreparator >> applyOnSuites: aCollection [
	"apply to every testSuite the specified process (see self applyOn:)"

	aCollection do: [ :suite | self applyOn: suite ]
]

{ #category : 'printing' }
SuitePreparator >> printOn: aStream [

	super printOn: aStream.
	aStream print: applyBlock
]
