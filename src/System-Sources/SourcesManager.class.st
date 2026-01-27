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
SourcesManager >> commentTimeStampAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SourcesManager >> protocolAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SourcesManager >> sourceCodeAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SourcesManager >> timeStampAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'writing' }
SourcesManager >> writeComment: aString stamp: aStamp of: aClass [

	self subclassResponsibility
]

{ #category : 'writing' }
SourcesManager >> writeSource: source of: aMethod withFooter: footer protocol: protocol timestamp: aTimestamp priorSourcePointer: priorSourcePointer [

	self subclassResponsibility
]
