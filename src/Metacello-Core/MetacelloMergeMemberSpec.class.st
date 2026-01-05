Class {
	#name : 'MetacelloMergeMemberSpec',
	#superclass : 'MetacelloMemberSpec',
	#category : 'Metacello-Core-Members',
	#package : 'Metacello-Core',
	#tag : 'Members'
}

{ #category : 'actions' }
MetacelloMergeMemberSpec >> applyToMap: map [

	map
		at: self name
		ifPresent: [ :aSpec | map at: self name put: (aSpec mergeSpec: self spec) ]
		ifAbsent: [ map at: self name put: self spec copy ]
]

{ #category : 'accessing' }
MetacelloMergeMemberSpec >> methodUpdateSelector [

	^#with:
]
