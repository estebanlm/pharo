Class {
	#name : 'CachedDebugScope',
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
CachedDebugScope class >> on: anOCMethodScope [

	^ self new
		  astScope: anOCMethodScope;
		  yourself
]

{ #category : 'adding' }
CachedDebugScope >> addChild: aCachedDebugScope [ 
	
	children := children copyWith: aCachedDebugScope
]

{ #category : 'accessing' }
CachedDebugScope >> bytecodeRange [

	^ bytecodeRange
]

{ #category : 'accessing' }
CachedDebugScope >> bytecodeRange: anObject [

	bytecodeRange := anObject
]

{ #category : 'accessing' }
CachedDebugScope >> debugScopeAt: aBytecodePC [

	"Precondition: this method is only valid if I match the argument PC"

	children do: [ :child |
		(child matchesBytecodePC: aBytecodePC)
			ifTrue: [ ^ child debugScopeAt: aBytecodePC ] ].
	
	"If none of my children match, then it's me that matches."
	^ self
]

{ #category : 'initialization' }
CachedDebugScope >> initialize [

	super initialize.
	children := #()
]

{ #category : 'accessing' }
CachedDebugScope >> matchesBytecodePC: aPC [

	^ bytecodeRange includes: aPC
]

{ #category : 'as yet unclassified' }
CachedDebugScope >> readVariableNamed: aString at: aContext [

	| variableDescriptor definingContext tempValue |
	variableDescriptor := variables detect: [ :e | e first = aString ].
	definingContext := aContext.
	variableDescriptor second timesRepeat: [
		definingContext := aContext sender ].

	tempValue := definingContext tempAt: variableDescriptor third.
	"If it is a temp vector, lookup inside"
	variableDescriptor size > 3 ifTrue: [
		tempValue := tempValue at: variableDescriptor fourth ].
	^ tempValue
]

{ #category : 'as yet unclassified' }
CachedDebugScope >> variableNames [
	
	^ variables collect: [ :each | each first ]
]

{ #category : 'as yet unclassified' }
CachedDebugScope >> variables [
	
	^ variables
]

{ #category : 'accessing' }
CachedDebugScope >> variables: aCollection [ 
	variables := aCollection
]
