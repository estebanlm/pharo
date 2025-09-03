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

{ #category : 'as yet unclassified' }
CachedDebugInfo >> precedingBytecodePC: aBytecodePC [
	
	| found |
	stopTable keys sorted do: [ :each |
		"If we went over the asked bytecode PC, we need to return the previous one"
		each >= aBytecodePC ifTrue: [ 
			"If asking for the bytecode before the first bytecode, fail"
			found ifNil: [ self error: 'There is no bytecode before PC ', aBytecodePC asString ].
			^ found ].
		found := each.
	].
]

{ #category : 'testing' }
CachedDebugInfo >> rangeForPC: aBytecodePC [

	^ (stopTable
		   at: aBytecodePC
		   ifAbsent: [ "If absent, somebody asked me for a *non-pc* because it is trying to guess.
		See for example Context >> #pcRangeContextIsActive:
		In that case, let's return the range of the preceding bytecodePC"
			   ^ self rangeForPC: (self precedingBytecodePC: aBytecodePC) ])
		  fifth
]

{ #category : 'testing' }
CachedDebugInfo >> readVariableNamed: aName at: aContext [

	^ (self debugScopeAt: aContext pc)
		  readVariableNamed: aName
		  at: aContext
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
CachedDebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]

{ #category : 'accessing' }
CachedDebugInfo >> variablesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variables
]
