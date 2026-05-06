Class {
	#name : 'MockToPrintCode',
	#superclass : 'Object',
	#category : 'debugger-CLI-Tests-Mock',
	#package : 'debugger-CLI-Tests',
	#tag : 'Mock'
}

{ #category : 'mock' }
MockToPrintCode class >> mockMethodForTesting [
	"Fake method to test printCode"

	| a b |
	a := 42.
	b := a + 1.
	^ b
]

{ #category : 'mock' }
MockToPrintCode >> mockMethodForTesting [
    "Fake method to test printCode"
    | a b |
    a := 42.
    b := a + 1.
    ^ b
]
