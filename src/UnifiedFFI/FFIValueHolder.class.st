Class {
	#name : 'FFIValueHolder',
	#superclass : 'Object',
	#instVars : [
		'handle',
		'type'
	],
	#category : 'UnifiedFFI-Objects',
	#package : 'UnifiedFFI',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
FFIValueHolder class >> newType: aTypeClass [

	^ self 
		newType: aTypeClass 
		handle: aTypeClass newBuffer
]

{ #category : 'instance creation' }
FFIValueHolder class >> newType: aTypeClass handle: aHandle [

	^ self basicNew
	initializeType: aTypeClass handle: aHandle;
	yourself
]

{ #category : 'accessing' }
FFIValueHolder >> handle [

	^ handle
]

{ #category : 'initialization' }
FFIValueHolder >> initializeType: aTypeClass handle: aHandle [

	type := aTypeClass.
	handle := aHandle.
	self initialize
]

{ #category : 'accessing' }
FFIValueHolder >> type [

	^ type
]
