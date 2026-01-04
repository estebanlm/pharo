Class {
	#name : 'MetacelloAddMemberSpec',
	#superclass : 'MetacelloMemberSpec',
	#category : 'Metacello-Core-Members',
	#package : 'Metacello-Core',
	#tag : 'Members'
}

{ #category : 'actions' }
MetacelloAddMemberSpec >> applyToMap: map [

	map at: self name put: self spec
]

{ #category : 'accessing' }
MetacelloAddMemberSpec >> methodUpdateSelector [

	^#overrides:
]
