Class {
	#name : 'CachedDebugInfo',
	#superclass : 'Object',
	#instVars : [
		'stopTable',
		'sourceCode',
		'rootScope'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'accessing' }
CachedDebugInfo >> debugScopeAt: aBytecodePC [ 
	
	^ rootScope debugScopeAt: aBytecodePC
]

{ #category : 'testing' }
CachedDebugInfo >> isSourceReturn: anInteger [ 
	
	^ (stopTable at: anInteger) third
]

{ #category : 'testing' }
CachedDebugInfo >> isSourceSend: anInteger [ 
	
	^ (stopTable at: anInteger) fourth
]

{ #category : 'testing' }
CachedDebugInfo >> isSourceStore: anInteger [ 
	
	^ (stopTable at: anInteger) second
]

{ #category : 'accessing' }
CachedDebugInfo >> rootScope: aCachedDebugScope [ 
	rootScope := aCachedDebugScope
]

{ #category : 'accessing' }
CachedDebugInfo >> shouldStopAt: anInteger [ 
	
	^ (stopTable at: anInteger) first
]

{ #category : 'accessing' }
CachedDebugInfo >> sourceCode [
	^ sourceCode
]

{ #category : 'accessing' }
CachedDebugInfo >> sourceCode: aString [ 
	sourceCode := aString
]

{ #category : 'accessing' }
CachedDebugInfo >> stopTable: aCollection [ 
	stopTable := aCollection
]
