Class {
	#name : 'SourcesManager',
	#superclass : 'Object',
	#classVars : [
		'Current'
	],
	#category : 'System-Sources-Sources',
	#package : 'System-Sources',
	#tag : 'Sources'
}

{ #category : 'accessing' }
SourcesManager class >> current [

	self flag: #sources. "Update"
	^ Current ifNil: [ Current := SourceFileArray default ]
]

{ #category : 'accessing' }
SourcesManager class >> current: anObject [

	Current := anObject
]

{ #category : 'accessing' }
SourcesManager >> sourceCodeAt: sourcePointer [

	^ self subclassResponsibility
]
