"
I am an abstract execution mode. I defined the way a testsuite should be executed (running simply all the suite, opening the debuger on the first failure or error...)
"
Class {
	#name : 'ExecutionMode',
	#superclass : 'Object',
	#instVars : [
		'executionBlock'
	],
	#category : 'TestRunner-Core-ExecutionModes',
	#package : 'TestRunner-Core',
	#tag : 'ExecutionModes'
}

{ #category : 'testing' }
ExecutionMode class >> debugMode [

	^ self executionBlock: [ :aTestCase | aTestCase debug ]
]

{ #category : 'private - accessing' }
ExecutionMode class >> executionBlock: aBlock [

	^ self new
		executionBlock: aBlock;
		yourself
]

{ #category : 'testing' }
ExecutionMode class >> executionMode [

	^ self executionBlock: [ :aTestCase | aTestCase run ]
]

{ #category : 'execution' }
ExecutionMode >> executeCase: aTestCase [
	"executes the giving test case then returns the result"

	^ executionBlock value: aTestCase 
]

{ #category : 'accessing' }
ExecutionMode >> executionBlock: anObject [

	executionBlock := anObject
]
