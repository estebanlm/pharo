"
I define a strategy to execute a test case for `NewTestRunner`. 
For simpler clases, a block can be provided to `ExecutionMode>>#executionBlock:` to run a test case. If you consider it more appropiate, override `ExecutionMode>>#executeCase:`

The following modes are provided through class methods:
- `ExecutionMode class >> #executionMode` runs a test case.
- `ExecutionMode class >> #debugMode` debugs a test case. 
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
