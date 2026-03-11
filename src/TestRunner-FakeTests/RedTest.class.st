Class {
	#name : 'RedTest',
	#superclass : 'MockTest',
	#classInstVars : [
		'ignoreTest'
	],
	#category : 'TestRunner-FakeTests',
	#package : 'TestRunner-FakeTests'
}

{ #category : 'tests' }
RedTest >> testFail [

	self assert: false
]

{ #category : 'tests' }
RedTest >> testPass [

	self assert: true
]

{ #category : 'tests' }
RedTest >> testWithError [

	self assert: nil
]
