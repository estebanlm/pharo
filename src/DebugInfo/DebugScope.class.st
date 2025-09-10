Class {
	#name : 'DebugScope',
	#superclass : 'Object',
	#instVars : [
		'bytecodeRange',
		'variables',
		'children'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
DebugScope class >> on: anOCMethodScope [

	^ self new
		  astScope: anOCMethodScope;
		  yourself
]

{ #category : 'adding' }
DebugScope >> addChild: aCachedDebugScope [ 
	
	children := children copyWith: aCachedDebugScope
]

{ #category : 'accessing' }
DebugScope >> bytecodeRange [

	^ bytecodeRange
]

{ #category : 'accessing' }
DebugScope >> bytecodeRange: anObject [

	bytecodeRange := anObject
]

{ #category : 'accessing' }
DebugScope >> debugScopeAt: aBytecodePC [

	"Precondition: this method is only valid if I match the argument PC"

	children do: [ :child |
		(child matchesBytecodePC: aBytecodePC)
			ifTrue: [ ^ child debugScopeAt: aBytecodePC ] ].
	
	"If none of my children match, then it's me that matches."
	^ self
]

{ #category : 'initialization' }
DebugScope >> initialize [

	super initialize.
	children := #()
]

{ #category : 'as yet unclassified' }
DebugScope >> isArgumentNamed: aName [

	| variableDescriptor |
	variableDescriptor := variables
		detect: [ :e | e first = aName ]
		ifNone: [ NotFound signal: 'Variable not found: ', aName ].
	^ variableDescriptor second
]

{ #category : 'accessing' }
DebugScope >> matchesBytecodePC: aPC [

	^ bytecodeRange includes: aPC
]

{ #category : 'as yet unclassified' }
DebugScope >> readVariableNamed: aName fromContext: aContext [

	| variableDescriptor definingContext tempValue |
	variableDescriptor := variables
		detect: [ :e | e first = aName ]
		ifNone: [ self error: 'Variable not found: ', aName  ].
	definingContext := aContext.
	variableDescriptor third timesRepeat: [
		definingContext := aContext outerContext ].

	tempValue := definingContext tempAt: variableDescriptor fourth.
	"If it is a temp vector, lookup inside"
	variableDescriptor size > 4 ifTrue: [
		tempValue := tempValue at: variableDescriptor fifth ].
	^ tempValue
]

{ #category : 'as yet unclassified' }
DebugScope >> variableNames [
	
	^ variables collect: [ :each | each first ]
]

{ #category : 'as yet unclassified' }
DebugScope >> variables [
	
	^ variables
]

{ #category : 'accessing' }
DebugScope >> variables: aCollection [ 
	variables := aCollection
]
