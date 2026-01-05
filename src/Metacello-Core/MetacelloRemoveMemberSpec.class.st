Class {
	#name : 'MetacelloRemoveMemberSpec',
	#superclass : 'MetacelloMemberSpec',
	#instVars : [
		'name'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MetacelloRemoveMemberSpec class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : 'actions' }
MetacelloRemoveMemberSpec >> applyToMap: map [

	map removeKey: self name ifAbsent: [ ]
]

{ #category : 'accessing' }
MetacelloRemoveMemberSpec >> name [

	^ name ifNil: [ super name ]
]

{ #category : 'accessing' }
MetacelloRemoveMemberSpec >> name: aString [

	name := aString
]
