Class {
	#name : 'MockToPrintCode',
	#superclass : 'Object',
	#category : 'Debugger-CLI-Tests-Mock',
	#package : 'Debugger-CLI-Tests',
	#tag : 'Mock'
}

{ #category : 'mock' }
MockToPrintCode class >> mockMethodForTesting [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * 2
]

{ #category : 'mock' }
MockToPrintCode class >> mockMethodForTesting: arg1 and: arg2 [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * arg1
]

{ #category : 'mock' }
MockToPrintCode >> mockMethodForTesting [ 
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * 2
]

{ #category : 'mock' }
MockToPrintCode >> mockMethodForTesting: arg1 and: arg2 [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * arg1
]
