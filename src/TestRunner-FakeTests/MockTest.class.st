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

{ #category : 'accessing' }
MockTest class >> doNotIgnore [ 

	ShouldIgnore := false
]

{ #category : 'accessing' }
MockTest class >> ignore [ 

	ShouldIgnore := true
]

{ #category : 'class initialization' }
MockTest class >> initialize [ 
		
	self ignore
]

{ #category : 'running' }
MockTest >> setUp [ 

	super setUp.
	self shouldIgnore ifTrue: [ self skip ]
]

{ #category : 'accessing' }
MockTest >> shouldIgnore [

	^ ShouldIgnore 
]

{ #category : 'accessing' }
MockTest >> shouldIgnore: anObject [

	ShouldIgnore := anObject
]
