"
I am a subclass of scope of packages for matching patterns
"
Class {
	#name : 'ClyMatchingPackageScope',
	#superclass : 'ClyPackageScope',
	#instVars : [
		'prefix'
	],
	#category : 'Calypso-SystemQueries-Scopes',
	#package : 'Calypso-SystemQueries',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
ClyMatchingPackageScope class >> defaultName [

	^ 'matching packages'
]

{ #category : 'initialization' }
ClyMatchingPackageScope class >> ofAll: basisObjects in: aNavigationEnvironment withName: aName [

	^ (self ofAll: basisObjects withName: aName) bindTo: aNavigationEnvironment
]

{ #category : 'initialization' }
ClyMatchingPackageScope class >> ofAll: basisObjects withName: aName [

	^self new
		basisObjects: basisObjects;
		prefix: aName 
]

{ #category : 'accessing' }
ClyMatchingPackageScope >> prefix: aName [

	prefix := aName
]

{ #category : 'printing' }
ClyMatchingPackageScope >> printBasisOn: aStream [

	basisObjects ifEmpty: [ ^ self ].
	aStream nextPutAll: prefix , '* (...)'
]
