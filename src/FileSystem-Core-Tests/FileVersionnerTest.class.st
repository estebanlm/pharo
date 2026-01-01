Class {
	#name : 'FileVersionnerTest',
	#superclass : 'TestCase',
	#instVars : [
		'fileSystem',
		'db99',
		'db09',
		'db10',
		'dir',
		'ddb99',
		'ddb09',
		'ddb10'
	],
	#category : 'FileSystem-Core-Tests-Base',
	#package : 'FileSystem-Core-Tests',
	#tag : 'Base'
}

{ #category : 'running' }
FileVersionnerTest >> setUp [ 
	super setUp.
	fileSystem := FileSystem memory.
	db99 := fileSystem root / 'BD.99.md'.
	db99 ensureCreateFile.
	db09 := fileSystem root / 'BD.09.md'.
	db09 ensureCreateFile.
	db10 := fileSystem root / 'BD.10.md'.
	db10 ensureCreateFile.
	
	dir := (fileSystem / 'dir') ensureCreateDirectory.
	ddb99 := fileSystem / 'dir' / 'BD.99.md'.
	ddb99 ensureCreateFile.
	ddb09 := fileSystem / 'dir' / 'BD.09.md'.
	ddb09 ensureCreateFile.
	ddb10 := fileSystem / 'dir' / 'BD.10.md'.
	ddb10 ensureCreateFile
	
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenExtensionIsEmpty [

	| ref vers |
	ref := (fileSystem / 'BD.10') ensureCreateFile.
	self assert: ref fullName equals: '/BD.10'.
	vers := (NewFileVersionner from: ref).
	vers useBasenameNumber.
	self assert: vers extractVersionOrZero equals: 10.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionIsAbsent [

	| ref vers |
	ref := (fileSystem / 'BD..md') ensureCreateFile.
	self assert: ref fullName equals: '/BD..md'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 0.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionIsAsBasename [

	| ref vers |
	ref := (fileSystem / '11.a.12') ensureCreateFile.
	self assert: ref fullName equals: '/11.a.12'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 0.
	
	ref := (fileSystem / '11.121.12') ensureCreateFile.
	self assert: ref fullName equals: '/11.121.12'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 121.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionIsAsExtension [

	| ref vers |
	ref := (fileSystem / 'BD.a.12') ensureCreateFile.
	self assert: ref fullName equals: '/BD.a.12'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 0.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionIsBogus [

	| ref vers |
	ref := (fileSystem / 'BD.a.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.a.md'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 0.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionIsDefined [

	| vers |
	self assert: ddb10 fullName equals: '/dir/BD.10.md'.
	vers := NewFileVersionner from: ddb10.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 10.
]

{ #category : 'tests - utilities' }
FileVersionnerTest >> testExtractVersionWhenVersionSectionDoesNotExist [

	| ref vers |
	ref := (fileSystem / 'BD.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.md'.
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self assert: vers extractVersionOrZero equals: 0.
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOf09Is10 [
	"This shows that we treat the number as a number and not as a list of digits
	where 11 follows 1 as in 
	1
	11
	111
	"
	
	| ref res vers |
	ref := (fileSystem / 'BD.09.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.09.md'.
	self assert: ref isAbsolute.
	
	vers := (NewFileVersionner from: ref).
	vers useBasenameNumberExtension. 
	res := vers nextVersionFileReference.

	self 
		assert: res fullName 
		equals:  '/BD.10.md'.
	self assert: res isAbsolute
		
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOf10Is11 [

	| vers |
	vers := NewFileVersionner from: ddb10.
	vers useBasenameNumberExtension.
	self assert: ddb10 fullName equals: '/dir/BD.10.md'.
	self 
		assert: vers nextVersionFileReference fullName
		equals: '/dir/BD.11.md' asFileReference fullName
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOf1Is2 [
	"This shows that we treat the number as a number and not as a list of digits
	where 11 follows 1 as in 
	1
	11
	111
	"
	
	| ref vers |
	ref := (fileSystem / 'BD.1.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.1.md'.
	
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	self 
		assert: vers nextVersionFileReference fullName 
		equals:  '/BD.2.md'.
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNoExtension [
	
	| ref should |
	ref := (fileSystem / 'BD') ensureCreateFile.
	self assert: ref fullName equals: '/BD'.

	should := false.	
	[ 
	| vers | 
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension. 
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: /BD structure does not follow the one of the pattern: #(#basename #number #extension)'. 
			should := true. ].
		
	self assert: should.
	
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNoNumber2 [
	
	| ref vers |
	
	ref := (fileSystem / 'BD.10') ensureCreateFile.
	self assert: ref fullName equals: '/BD.10'.

	vers := NewFileVersionner from: ref.
	vers useBasenameNumber.
	self assert: vers nextVersionFileReference fullName equals:  '/BD.11'.
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNoNumberBaseNumber [
	
	| ref should |
	ref := (fileSystem / 'BD.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.md'.

	should := false.	
	[ 
	| vers |
	vers := NewFileVersionner from: ref.
	vers useBasenameNumber.
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: /BD.md second element is not a number.'. 
			should := true. ].
		
	self assert: should.
	
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNoNumberBaseNumberExt [
	
	| ref should |
	ref := (fileSystem / 'BD.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.md'.

	should := false.	
	[ 
	| vers |
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: /BD.md structure does not follow the one of the pattern: #(#basename #number #extension)'. 
			should := true. ].
		
	self assert: should.
	
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNumberBeingEmpty [
	
	| ref should |
	ref := (fileSystem / 'BD..md') ensureCreateFile.
	self assert: ref fullName equals: '/BD..md'.

	should := false.	
	[ 
	| vers |
	vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: /BD..md structure does not follow the one of the pattern: #(#basename #number #extension)'. 
			should := true. ].
		
	self assert: should.
	
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfNumberNotANumber [
	
	| ref should vers |
	ref := (fileSystem / 'BD.a.md') ensureCreateFile.
	self assert: ref fullName equals: '/BD.a.md'.

	should := false.	
	[ vers := NewFileVersionner from: ref.
	vers useBasenameNumberExtension.
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: /BD.a.md second element is not a number.'. 
			should := true. ].
		
	self assert: should.
	
]

{ #category : 'tests - next version' }
FileVersionnerTest >> testNextVersionOfWhenNoPattern [
	
	| ref should |
	ref := (fileSystem / 'BD.10.md') ensureCreateFile.

	should := false.	
	[ 
	| vers |
	vers := NewFileVersionner from: ref.
	vers nextVersionFileReference ]
		on: Error
		do: [ :ex |
			self assert: ex description equals: 'Error: no pattern set!'. 
			should := true ].
		
	self assert: should.
	
]
