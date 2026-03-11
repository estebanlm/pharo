"
Don't edit these classes. They are used else where for tests. Changing anything can make some tests fail
"
Class {
	#name : 'MockTest',
	#superclass : 'TestCase',
	#classVars : [
		'ShouldIgnore'
	],
	#classInstVars : [
		'ignore'
	],
	#category : 'TestRunner-FakeTests',
	#package : 'TestRunner-FakeTests'
}

{ #category : 'running' }
MockTest >> setUp [ 

	super setUp.
	self shouldIgnore ifTrue: [ self skip ]
]

{ #category : 'accessing' }
MockTest >> shouldIgnore [

	^ ShouldIgnore ifNil: [ ShouldIgnore := true ]
]

{ #category : 'accessing' }
MockTest >> shouldIgnore: anObject [

	ShouldIgnore := anObject
]
