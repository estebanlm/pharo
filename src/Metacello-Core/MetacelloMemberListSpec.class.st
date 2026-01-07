Class {
	#name : 'MetacelloMemberListSpec',
	#superclass : 'MetacelloSpec',
	#instVars : [
		'list',
		'memberMap'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'testing' }
MetacelloMemberListSpec class >> isAbstract [

	^ self = MetacelloMemberListSpec
]

{ #category : 'visiting' }
MetacelloMemberListSpec >> acceptVisitor: aVisitor [

	self error: 'Should not be visitable..'
]

{ #category : 'actions' }
MetacelloMemberListSpec >> add: aSpec [

	self addMember: (MetacelloAddMemberSpec spec: aSpec)
]

{ #category : 'adding' }
MetacelloMemberListSpec >> addMember: aMember [

	self list add: aMember.
	self clearMemberMap
]

{ #category : 'private' }
MetacelloMemberListSpec >> clearMemberMap [

	memberMap := nil.
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> collect: aBlock [ 
	| newCollection |
	newCollection :=OrderedCollection new.
	self do: [:each | newCollection add: (aBlock value: each)].
	^ newCollection
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> detect: aBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Answer the first element for which aBlock evaluates to true."

	^ self detect: aBlock ifNone: [ self error: 'Object is not in the collection.' ]
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Answer the first element for which aBlock evaluates to true. If none  
	evaluate to true, then evaluate the argument, exceptionBlock."

	self
		do: [ :each | 
			(aBlock value: each)
				ifTrue: [ ^ each ] ].
	^ exceptionBlock value
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> do: aBlock [

	self specs do: aBlock
]

{ #category : 'testing' }
MetacelloMemberListSpec >> isEmpty [

	^self list isEmpty
]

{ #category : 'accessing' }
MetacelloMemberListSpec >> list [

	^ list ifNil: [ list := OrderedCollection new ]
]

{ #category : 'accessing' }
MetacelloMemberListSpec >> list: aCollection [

	list := aCollection.
	self clearMemberMap
]

{ #category : 'accessing' }
MetacelloMemberListSpec >> map [

	| map |
	memberMap ifNotNil: [ ^ memberMap ].
	map := Dictionary new.
	self list do: [ :member | member applyToMap: map ].
	^ memberMap := map
]

{ #category : 'actions' }
MetacelloMemberListSpec >> merge: aSpec [

	self addMember: (MetacelloMergeMemberSpec spec: aSpec)
]

{ #category : 'merging' }
MetacelloMemberListSpec >> mergeSpec: anotherSpec [

	| newSpec |
	newSpec := super mergeSpec: anotherSpec.
	newSpec list: self list copy.
	anotherSpec list do: [ :groupMember | newSpec addMember: groupMember ].
	^ newSpec
]

{ #category : 'testing' }
MetacelloMemberListSpec >> notEmpty [

	^self list notEmpty
]

{ #category : 'copying' }
MetacelloMemberListSpec >> postCopy [

	super postCopy.
	list := list copy.
	self clearMemberMap
]

{ #category : 'printing' }
MetacelloMemberListSpec >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ['.
	self specs
		ifEmpty: [ aStream nextPutAll: 'Empty' ]
		ifNotEmpty: [ :specs | specs do: [ :spec | aStream nextPutAll: spec name ] separatedBy: [ aStream nextPutAll: ', ' ] ].
	aStream nextPutAll: ']'
]

{ #category : 'removing' }
MetacelloMemberListSpec >> remove: aSpec [

	self addMember: (MetacelloRemoveMemberSpec spec: aSpec)
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> select: aBlock [ 
	| newCollection |
	newCollection := OrderedCollection new.
	self do: [:each | (aBlock value: each) ifTrue: [newCollection add: each]].
	^newCollection
]

{ #category : 'enumeration' }
MetacelloMemberListSpec >> specListDo: aBlock [

	self list do: [:member |  aBlock value: member spec ]
]

{ #category : 'accessing' }
MetacelloMemberListSpec >> specs [
	"Return the list of specs I contains once all members are applied."

	^ self map values
]
