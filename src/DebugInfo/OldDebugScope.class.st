Class {
	#name : 'OldDebugScope',
	#superclass : 'Object',
	#instVars : [
		'astScope'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
OldDebugScope class >> on: anOCMethodScope [

	^ self new
		  astScope: anOCMethodScope;
		  yourself
]

{ #category : 'accessing' }
OldDebugScope >> astScope [
	^ astScope
]

{ #category : 'as yet unclassified' }
OldDebugScope >> astScope: anOCMethodScope [ 
	
	astScope := anOCMethodScope 
]

{ #category : 'testing' }
OldDebugScope >> isArgumentNamed: aName [

	^ (self variableNamed: aName) isArgumentVariable
]

{ #category : 'testing' }
OldDebugScope >> readVariableNamed: aName at: aContext [

	^ (self variableNamed: aName) readInContext: aContext
]

{ #category : 'testing' }
OldDebugScope >> variableNamed: aName [

	^ self variables
		detect: [ :e | e name = aName ]
		ifNone: [ self error: 'Variable not found: ', aName  ]
]

{ #category : 'as yet unclassified' }
OldDebugScope >> variableNames [
	
	^ astScope allTempNames
]

{ #category : 'as yet unclassified' }
OldDebugScope >> variables [
	
	^ astScope allTemps
]
