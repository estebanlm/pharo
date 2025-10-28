"
I represent instance side of classes
"
Class {
	#name : 'ClyInstanceSideScope',
	#superclass : 'ClyMetaLevelClassScope',
	#category : 'Calypso-SystemQueries-Scopes',
	#package : 'Calypso-SystemQueries',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
ClyInstanceSideScope class >> defaultName [
	^'inst. side'
]

{ #category : 'testing' }
ClyInstanceSideScope class >> isInstanceSide [

	^ true
]

{ #category : 'class selection' }
ClyInstanceSideScope class >> metaLevelOf: aClass [
	^aClass instanceSide
]

{ #category : 'testing' }
ClyInstanceSideScope >> isInstanceSide [
	^ self class isInstanceSide
]
