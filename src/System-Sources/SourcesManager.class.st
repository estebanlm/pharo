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
	^ Current ifNil: [ Current := FilesSourcesManager default ]
]

{ #category : 'accessing' }
SourcesManager class >> current: anObject [

	Current := anObject
]

{ #category : 'system startup' }
SourcesManager class >> shutDown: isImageClosing [

	isImageClosing ifTrue: [ self current shutDown ]
]

{ #category : 'system startup' }
SourcesManager class >> startUp: resuming [

	resuming ifTrue: [ self current startUp ]
]

{ #category : 'accessing' }
SourcesManager >> commentTimeStampAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'public - string writing' }
SourcesManager >> deferFlushDuring: aBlock [
	"If a specific implementation of SourcesManager is using a flush system, I can be overriden to defer the flushing during a block."

	aBlock value
]

{ #category : 'public - file system operations' }
SourcesManager >> ensureFlushing [
	"Ensure the sources manager flush its streams, if it has some"

	
]

{ #category : 'copying' }
SourcesManager >> imageMovedWithNewName: newNameWithoutSuffix [
	"I am called when the image is relocated in case the source manager needs to update itself following the change."

	self subclassResponsibility
]

{ #category : 'testing' }
SourcesManager >> isSourcesPresentInSystem [

	^ self subclassResponsibility
]

{ #category : 'event-listening' }
SourcesManager >> logClassAdded: announcement [

	self subclassResponsibility
]

{ #category : 'event-listening' }
SourcesManager >> logClassRemoved: announcement [

	self subclassResponsibility
]

{ #category : 'event-listening' }
SourcesManager >> logClassRenamed: announcement [

	self subclassResponsibility
]

{ #category : 'event-listening' }
SourcesManager >> logMethodRemoved: announcement [

	self subclassResponsibility
]

{ #category : 'accessing' }
SourcesManager >> protocolAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'private' }
SourcesManager >> registerToAnnouncements [

	self class codeChangeAnnouncer weak
		when: ClassAdded send: #logClassAdded: to: self;
		when: ClassRemoved send: #logClassRemoved: to: self;
		when: ClassRenamed send: #logClassRenamed: to: self;
		when: MethodRemoved send: #logMethodRemoved: to: self
]

{ #category : 'querying' }
SourcesManager >> reportString [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
SourcesManager >> reset [

	
]

{ #category : 'system startup' }
SourcesManager >> shutDown [
	"Hook during image closing."

	self unsubscribeToAnnouncements
]

{ #category : 'accessing' }
SourcesManager >> sourceCodeAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'system startup' }
SourcesManager >> startUp [
	"Hook during image opening."

	self registerToAnnouncements
]

{ #category : 'accessing' }
SourcesManager >> timeStampAt: sourcePointer [

	^ self subclassResponsibility
]

{ #category : 'private' }
SourcesManager >> unsubscribeToAnnouncements [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'writing' }
SourcesManager >> writeComment: aString stamp: aStamp of: aClass [

	self subclassResponsibility
]

{ #category : 'writing' }
SourcesManager >> writeSource: source of: aMethod withFooter: footer protocol: protocol timestamp: aTimestamp priorSourcePointer: priorSourcePointer [

	self subclassResponsibility
]
