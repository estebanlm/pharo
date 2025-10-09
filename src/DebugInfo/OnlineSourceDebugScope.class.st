"
I represent a scope wrapping a compiler scope.

I provide information about variables available in the scope and how to read them.
"
Class {
	#name : 'OnlineSourceDebugScope',
	#superclass : 'Object',
	#instVars : [
		'astScope'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
OnlineSourceDebugScope class >> on: anOCMethodScope [

	^ self new
		  astScope: anOCMethodScope;
		  yourself
]

{ #category : 'accessing' }
OnlineSourceDebugScope >> astScope [
	^ astScope
]

{ #category : 'accessing' }
OnlineSourceDebugScope >> astScope: anOCMethodScope [ 
	
	astScope := anOCMethodScope 
]

{ #category : 'api' }
OnlineSourceDebugScope >> isArgumentNamed: aName [

	^ (self variableNamed: aName) isArgumentVariable
]

{ #category : 'api' }
OnlineSourceDebugScope >> readVariableNamed: aName fromContext: aContext [

	^ (self variableNamed: aName) readInContext: aContext
]

{ #category : 'api' }
OnlineSourceDebugScope >> variableNamed: aName [

	^ self variables
		detect: [ :e | e name = aName ]
		ifNone: [ self error: 'Variable not found: ', aName  ]
]

{ #category : 'accessing' }
OnlineSourceDebugScope >> variableNames [
	
	^ astScope allTempNames
]

{ #category : 'accessing' }
OnlineSourceDebugScope >> variables [
	
	^ astScope allTemps
]
