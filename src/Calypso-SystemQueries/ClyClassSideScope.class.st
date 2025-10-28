"
I represent class side of classes
"
Class {
	#name : 'ClyClassSideScope',
	#superclass : 'ClyMetaLevelClassScope',
	#category : 'Calypso-SystemQueries-Scopes',
	#package : 'Calypso-SystemQueries',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
ClyClassSideScope class >> defaultName [
	^'class side'
]

{ #category : 'testing' }
ClyClassSideScope class >> isInstanceSide [

	^ false
]

{ #category : 'class selection' }
ClyClassSideScope class >> metaLevelOf: aClass [
	^aClass classSide
]

{ #category : 'testing' }
ClyClassSideScope >> isInstanceSide [
	^ self class isInstanceSide
]

{ #category : 'queries' }
ClyClassSideScope >> methodsDo: aBlock [

	self classesDo: [ :eachClass |
		self metaLevelsOf: eachClass do: [ :concreteMetaLevelClass |
			concreteMetaLevelClass visibleMethods do: aBlock ] ]
]
