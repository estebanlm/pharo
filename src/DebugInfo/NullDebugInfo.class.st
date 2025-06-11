Class {
	#name : 'NullDebugInfo',
	#superclass : 'Object',
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'testing' }
NullDebugInfo >> isSourceReturn: aBytecodePC [

	^ true
]

{ #category : 'testing' }
NullDebugInfo >> isSourceSend: aBytecodePC [

	^ true
]

{ #category : 'testing' }
NullDebugInfo >> isSourceStore: aBytecodePC [
	
	^ true
]

{ #category : 'accessing' }
NullDebugInfo >> rangeForPC: aPC [

	^ 1 to: 0
]

{ #category : 'accessing' }
NullDebugInfo >> shouldStopAt: aBytecodePC [

	^ true
]

{ #category : 'accessing' }
NullDebugInfo >> sourceCode [
	
	^ ''
]

{ #category : 'accessing' }
NullDebugInfo >> variablesAt: aBytecodePC [

	^ #()
]
