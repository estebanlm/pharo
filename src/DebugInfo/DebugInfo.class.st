Class {
	#name : 'DebugInfo',
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
DebugInfo >> debugScopeAt: aBytecodePC [ 
	
	^ rootScope debugScopeAt: aBytecodePC
]

{ #category : 'testing' }
DebugInfo >> isArgumentNamed: aName at: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) isArgumentNamed: aName
]

{ #category : 'testing' }
DebugInfo >> isSourceReturn: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) third
]

{ #category : 'testing' }
DebugInfo >> isSourceSend: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) fourth
]

{ #category : 'testing' }
DebugInfo >> isSourceStore: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) second
]

{ #category : 'as yet unclassified' }
DebugInfo >> precedingBytecodePC: aBytecodePC [
	
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
DebugInfo >> rangeForPC: aBytecodePC [

	^ (stopTable
		   at: aBytecodePC
		   ifAbsent: [ "If absent, somebody asked me for a *non-pc* because it is trying to guess.
		See for example Context >> #pcRangeContextIsActive:
		In that case, let's return the range of the preceding bytecodePC"
			   ^ self rangeForPC: (self precedingBytecodePC: aBytecodePC) ])
		  fifth
]

{ #category : 'testing' }
DebugInfo >> readVariableNamed: aName fromContext: aContext [

	^ (self debugScopeAt: aContext pc)
		  readVariableNamed: aName
		  fromContext: aContext
]

{ #category : 'accessing' }
DebugInfo >> rootScope: aCachedDebugScope [ 
	rootScope := aCachedDebugScope
]

{ #category : 'accessing' }
DebugInfo >> shouldStopAt: aBytecodePC [ 
	
	^ (stopTable at: aBytecodePC) first
]

{ #category : 'accessing' }
DebugInfo >> sourceCode [
	^ sourceCode
]

{ #category : 'accessing' }
DebugInfo >> sourceCode: aString [ 
	sourceCode := aString
]

{ #category : 'accessing' }
DebugInfo >> stopTable: aCollection [ 
	stopTable := aCollection
]

{ #category : 'accessing' }
DebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]

{ #category : 'accessing' }
DebugInfo >> variablesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variables
]
