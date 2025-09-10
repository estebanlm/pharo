Class {
	#name : 'DebugInfo',
	#superclass : 'Object',
	#instVars : [
		'stopTable',
		'sourceCode',
		'rootScope',
		'stopTableDictionary'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'accessing' }
DebugInfo >> debugScopeAt: aBytecodePC [ 
	
	^ rootScope debugScopeAt: aBytecodePC
]

{ #category : 'accessing' }
DebugInfo >> inflatedStopTableInfoFromFlags: flags [

	| stopTableInfo |
	stopTableInfo := OrderedCollection new.
	1 to: 3 "Num of flags" do: [ :e | 
		stopTableInfo addLast: (flags anyMask: 1) ].
	^ stopTableInfo
]

{ #category : 'testing' }
DebugInfo >> isArgumentNamed: aName at: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) isArgumentNamed: aName
]

{ #category : 'testing' }
DebugInfo >> isSourceReturn: aBytecodePC [

	^ (self stopTableDictionary at: aBytecodePC ifAbsent: [ ^ false ]) second
]

{ #category : 'testing' }
DebugInfo >> isSourceSend: aBytecodePC [ 
	
	^ (self stopTableDictionary at: aBytecodePC ifAbsent: [ ^ false ]) third
]

{ #category : 'testing' }
DebugInfo >> isSourceStore: aBytecodePC [ 
	
	^ (self stopTableDictionary at: aBytecodePC ifAbsent: [ ^ false ]) first
]

{ #category : 'as yet unclassified' }
DebugInfo >> precedingBytecodePC: aBytecodePC [
	
	| found |
	self stopTableDictionary keys sorted do: [ :each |
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

	^ (self stopTableDictionary
		   at: aBytecodePC
		   ifAbsent: [ "If absent, somebody asked me for a *non-pc* because it is trying to guess.
		See for example Context >> #pcRangeContextIsActive:
		In that case, let's return the range of the preceding bytecodePC"
			   ^ self rangeForPC: (self precedingBytecodePC: aBytecodePC) ])
		  fourth
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

	^ self stopTableDictionary includesKey: aBytecodePC
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
DebugInfo >> stopTable [
	
	^ stopTable
]

{ #category : 'accessing' }
DebugInfo >> stopTable: aCollection [ 
	stopTable := aCollection
]

{ #category : 'accessing' }
DebugInfo >> stopTableDictionary [

	stopTableDictionary ifNotNil: [ ^ stopTableDictionary ].


	stopTableDictionary := (stopTable groupsOf: 4 atATimeCollect: [ :e |
			                        | stopTableFlags stopTableRange stopTableInflatedInfo |
			                        stopTableFlags := e second.
			                        stopTableRange := e third to: e fourth.
			                        stopTableInflatedInfo := (self
				                                                  inflatedStopTableInfoFromFlags:
				                                                  stopTableFlags)
				                                                 copyWith:
				                                                 stopTableRange.

			                        e first -> stopTableInflatedInfo ])
		                       asDictionary.
	^ stopTableDictionary
]

{ #category : 'accessing' }
DebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]

{ #category : 'accessing' }
DebugInfo >> variablesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variables
]
