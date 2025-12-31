"
I'm an utility class to manage numbered file pattern e.g. 'games.12.ston' and I offers simple way to get the following version (e.g., 'games.13.ston') or the last version between a set of files. 

To work the user should explicitly set the pattern of the files. 
So far I define two.
- basename.number
- basename.number.extension


## Core methods

- nextVersion : Answer the next available version number for the file.
- lastFileFor:extension: Returns the latest version number if the file name is already numbered; otherwise, returns 0.
"
Class {
	#name : 'NewFileVersionner',
	#superclass : 'Object',
	#instVars : [
		'fileReference',
		'pattern'
	],
	#category : 'FileSystem-Core-Public',
	#package : 'FileSystem-Core',
	#tag : 'Public'
}

{ #category : 'instance creation' }
NewFileVersionner class >> from: aFileReference [

 	^ self new fileReference: aFileReference ; yourself
]

{ #category : 'API' }
NewFileVersionner >> extractVersionOrZero [
	"Given a pattern basename.number.extension returns number.
	All the other case returns 0."
	
	| tokenizedFilename |
	pattern ifNil: [  Error signal: 'no pattern set!' ].
	
	tokenizedFilename := fileReference basename findTokens: '.'.
	^ tokenizedFilename size = pattern size
		ifFalse: [ 0 ]
		ifTrue: [ 
			| numberOrNil |
			numberOrNil := NumberParser parse: (tokenizedFilename at: (self indexOfNumber)) onError: [ nil ].
			numberOrNil ifNil: [ 0 ] ifNotNil: [ :n | n ]]

]

{ #category : 'accessing' }
NewFileVersionner >> fileReference [

	^ fileReference
]

{ #category : 'accessing' }
NewFileVersionner >> fileReference: aFileReference [

	fileReference := aFileReference
]

{ #category : 'pattern' }
NewFileVersionner >> indexOfNumber [

	^ pattern indexOf: #number
]

{ #category : 'API' }
NewFileVersionner >> nextFileReferenceVersion [

	"Assumes a file (or folder) name follows the pattern prior.number.extension, increment the version number and answer the new filereference. If a version number is not found, raise an error"

	|  tokenizedFilename version |
	pattern ifNil: [  Error signal: 'no pattern set!' ].
	
	tokenizedFilename := fileReference basename findTokens: '.'.
	version := tokenizedFilename size = 3
		ifFalse: [ 0 ]
		ifTrue: [ 
			| numberOrNil |
			numberOrNil := NumberParser parse: (tokenizedFilename at: 2) onError: [ nil ].
			numberOrNil ifNil: [ 0 ] ifNotNil: [ :n | n ]].
	version isZero 
		ifTrue: [ Error new signal: fileReference fullName ,  ' second element of basename is not a number.'].
	
	 ^ ( fileReference parent / (tokenizedFilename first , '.' , (version + 1) asString , '.' ,  fileReference extension)) asFileReference
]

{ #category : 'pattern' }
NewFileVersionner >> useBasenameNumber [
	
	pattern := #(basename number)
]

{ #category : 'pattern' }
NewFileVersionner >> useBasenameNumberExtension [
	
	pattern := #(basename number extension)
]
