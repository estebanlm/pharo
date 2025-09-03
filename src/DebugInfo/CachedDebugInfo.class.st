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
CachedDebugInfo >> isSourceReturn: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) third
]

{ #category : 'testing' }
CachedDebugInfo >> isSourceSend: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) fourth
]

{ #category : 'testing' }
CachedDebugInfo >> isSourceStore: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) second
]

{ #category : 'testing' }
CachedDebugInfo >> rangeForPC: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) fifth
]

{ #category : 'accessing' }
CachedDebugInfo >> rootScope: aCachedDebugScope [ 
	rootScope := aCachedDebugScope
]

{ #category : 'accessing' }
CachedDebugInfo >> shouldStopAt: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) first
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

{ #category : 'accessing' }
CachedDebugInfo >> variablesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variables
]
