Class {
	#name : 'ClyClassChange',
	#superclass : 'Object',
	#instVars : [
		'affectedClass'
	],
	#category : 'Calypso-SystemQueries-Domain',
	#package : 'Calypso-SystemQueries',
	#tag : 'Domain'
}

{ #category : 'instance creation' }
ClyClassChange class >> of: aClass [

	^ self new affectedClass: aClass
]

{ #category : 'accessing' }
ClyClassChange >> affectedClass [

	^ affectedClass
]

{ #category : 'accessing' }
ClyClassChange >> affectedClass: anObject [

	affectedClass := anObject
]

{ #category : 'testing' }
ClyClassChange >> handlesAnnouncement: anAnnouncement [

	^ anAnnouncement affectsClass: affectedClass
]
