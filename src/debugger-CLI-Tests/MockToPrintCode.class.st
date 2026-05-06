Class {
	#name : 'MockToPrintCode',
	#superclass : 'Object',
	#category : 'debugger-CLI-Tests-Mock',
	#package : 'debugger-CLI-Tests',
	#tag : 'Mock'
}

{ #category : 'mock' }
MockToPrintCode class >> mockMethodForTesting: arg [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * arg
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
MockToPrintCode >> mockMethodForTesting: arg [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * arg
]

{ #category : 'mock' }
MockToPrintCode >> mockMethodForTesting: arg1 and: arg2 [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b * arg1
]
