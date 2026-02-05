"
After building a TestSuite and before executing its tests, we would like to apply to it some process like randomisation. I am an abstract representation of any class intented to do such things.
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
SuitePreparator class >> anySuitePreparatorClass [

	^ self new
]

{ #category : 'factory' }
SuitePreparator class >> applyBlock: aBlock [

	^ self new
		applyBlock: aBlock;
		yourself
]

{ #category : 'factory' }
SuitePreparator class >> shuffleSuitePreparatorClass [

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
