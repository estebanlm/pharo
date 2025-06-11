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

{ #category : 'as yet unclassified' }
OldDebugScope >> variableNames [
	
	^ astScope allTempNames
]

{ #category : 'as yet unclassified' }
OldDebugScope >> variables [
	
	^ astScope allTemps
]
