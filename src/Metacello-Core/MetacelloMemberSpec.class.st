Class {
	#name : 'MetacelloMemberSpec',
	#superclass : 'MetacelloSpec',
	#instVars : [
		'spec'
	],
	#category : 'Metacello-Core-Members',
	#package : 'Metacello-Core',
	#tag : 'Members'
}

{ #category : 'testing' }
MetacelloMemberSpec class >> isAbstract [

	^ self = MetacelloMemberSpec
]

{ #category : 'instance creation' }
MetacelloMemberSpec class >> spec: aSpec [

	^ self new
		  spec: aSpec;
		  yourself
]

{ #category : 'visiting' }
MetacelloMemberSpec >> acceptVisitor: aVisitor [

	self error: 'Should not be visitable..'
]

{ #category : 'actions' }
MetacelloMemberSpec >> applyToMap: map [

	self subclassResponsibility
]

{ #category : 'printing' }
MetacelloMemberSpec >> configMethodCascadeOn: aStream last: lastCascade indent: indent [

	self spec 
		configMethodCascadeOn: aStream 
		member: self 
		last: lastCascade 
		indent: indent
]

{ #category : 'printing' }
MetacelloMemberSpec >> configMethodOn: aStream indent: indent [

	aStream
		nextPutAll: self class name asString;
		nextPutAll: ' member: ('.
	self spec configMethodOn: aStream indent: indent.
	aStream nextPutAll: ')'
]

{ #category : 'accessing' }
MetacelloMemberSpec >> methodUpdateSelector [

	^self subclassResponsibility
]

{ #category : 'accessing' }
MetacelloMemberSpec >> name [

	^ self spec name
]

{ #category : 'accessing' }
MetacelloMemberSpec >> sourceName [

	^self name
]

{ #category : 'accessing' }
MetacelloMemberSpec >> spec [

	^spec
]

{ #category : 'accessing' }
MetacelloMemberSpec >> spec: aMetacelloSpec [

	spec := aMetacelloSpec
]
