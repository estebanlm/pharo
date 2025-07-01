Class {
	#name : 'FFIValueHolderTest',
	#superclass : 'TestCase',
	#category : 'UnifiedFFI-Tests',
	#package : 'UnifiedFFI-Tests'
}

{ #category : 'tests' }
FFIValueHolderTest >> testBasicTypeCanBeHolded [
	| holder |

	holder := FFIInt64 newValueHolder.

	self assert: holder type equals: FFIInt64.
	self assert: (holder getHandle isKindOf: ByteArray).
	self assert: holder getHandle size equals: FFIInt64 newBuffer size.	
	
	holder value: 42.
	self assert: holder value equals: 42
]

{ #category : 'tests' }
FFIValueHolderTest >> testOpaqueObjectTypeCanBeHolded [
	| holder |

	holder := FFIOpaqueObject newValueHolder.

	self assert: holder type equals: FFIOpaqueObject.
	self assert: (holder getHandle isKindOf: ByteArray).
	self assert: holder getHandle size equals: FFIInt64 newBuffer size.	

	holder value: (FFIOpaqueObject fromHandle: ExternalAddress null).
	self assert: holder value getHandle equals: ExternalAddress null
]
