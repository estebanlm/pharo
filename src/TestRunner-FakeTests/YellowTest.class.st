Class {
	#name : 'YellowTest',
	#superclass : 'MockTest',
	#category : 'TestRunner-FakeTests',
	#package : 'TestRunner-FakeTests'
}

{ #category : 'tests' }
YellowTest >> testFail [

	self assert: false
]

{ #category : 'tests' }
YellowTest >> testPass [
	self assert: true.
]
