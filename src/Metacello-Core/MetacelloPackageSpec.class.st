Class {
	#name : 'MetacelloPackageSpec',
	#superclass : 'MetacelloAbstractPackageSpec',
	#instVars : [
		'project',
		'name',
		'repositories',
		'preLoadDoIt',
		'postLoadDoIt'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MetacelloPackageSpec class >> project: aMetacelloProject [

	^ self new
		  project: aMetacelloProject;
		  yourself
]

{ #category : 'visiting' }
MetacelloPackageSpec >> acceptVisitor: aVisitor [

	^ aVisitor visitPackageSpec: self
]

{ #category : 'loading' }
MetacelloPackageSpec >> ensureLoadedForDevelopmentUsing: aTarget [
	"noop"

	
]

{ #category : 'loading' }
MetacelloPackageSpec >> ensureLoadedForDevelopmentUsing: aTarget ithEngine: anEngine [
	"noop"

	
]

{ #category : 'accessing' }
MetacelloPackageSpec >> getRepositories [
    "raw access to iv"

    ^ repositories
]

{ #category : 'private' }
MetacelloPackageSpec >> includesForPackageOrdering [
  ^ self includes
]

{ #category : 'accessing' }
MetacelloPackageSpec >> info [
	"test compatibility method"

	^self
]

{ #category : 'merging' }
MetacelloPackageSpec >> mergeMap [

	| map |
	map := super mergeMap.
	map at: #repositories put: self repositories.
	map at: #preLoadDoIt put: preLoadDoIt.
	map at: #postLoadDoIt put: postLoadDoIt.
	^map
]

{ #category : 'merging' }
MetacelloPackageSpec >> mergeSpec: anotherSpec [

	| newSpec anotherRepositories |
	newSpec := super mergeSpec: anotherSpec.
	(anotherRepositories := anotherSpec mergeMap at: #repositories) notEmpty ifTrue: [
			newSpec repositories: (self repositories isEmpty
					 ifTrue: [ anotherRepositories ]
					 ifFalse: [ self repositories mergeSpec: anotherRepositories ]) ].

	anotherSpec name ifNotNil: [ newSpec name: anotherSpec name ].
	^ newSpec
]

{ #category : 'querying' }
MetacelloPackageSpec >> name [

	^name
]

{ #category : 'accessing' }
MetacelloPackageSpec >> name: aString [

	name := aString trim
]

{ #category : 'merging' }
MetacelloPackageSpec >> nonOverridable [

	^super nonOverridable, #( repositories)
]

{ #category : 'loading' }
MetacelloPackageSpec >> packageSpecsInLoadOrder [

	^ { self }
]

{ #category : 'copying' }
MetacelloPackageSpec >> postCopy [

	super postCopy.
	repositories := repositories copy.
]

{ #category : 'querying' }
MetacelloPackageSpec >> postLoadDoIt [

	^postLoadDoIt
]

{ #category : 'loading' }
MetacelloPackageSpec >> postLoadDoIt: aSymbol [

	self validateDoItSelector: aSymbol.
	postLoadDoIt := aSymbol
]

{ #category : 'querying' }
MetacelloPackageSpec >> preLoadDoIt [

	^preLoadDoIt
]

{ #category : 'accessing' }
MetacelloPackageSpec >> preLoadDoIt: aSymbol [

	self validateDoItSelector: aSymbol.
	preLoadDoIt := aSymbol
]

{ #category : 'accessing' }
MetacelloPackageSpec >> project [

	^ project
]

{ #category : 'accessing' }
MetacelloPackageSpec >> project: aMetacelloProject [

	project := aMetacelloProject
]

{ #category : 'visiting' }
MetacelloPackageSpec >> projectDo: projectBlock packageDo: packageBlock groupDo: groupBlock [

	packageBlock value: self
]

{ #category : 'querying' }
MetacelloPackageSpec >> repositories [

	^ repositories ifNil: [ repositories := MetacelloRepositoriesSpec new ]
]

{ #category : 'querying' }
MetacelloPackageSpec >> repositories: anObject [
	repositories := anObject
]

{ #category : 'accessing' }
MetacelloPackageSpec >> repository: aStringOrMetacelloRepositorySpec [

	self repositories repository: aStringOrMetacelloRepositorySpec
]

{ #category : 'accessing' }
MetacelloPackageSpec >> repository: aString username: username password: password [

	self repositories repository: aString username: username password: password
]

{ #category : 'loading' }
MetacelloPackageSpec >> repositoryDescriptions [
    ^ self repositorySpecs collect: [ :repoSpec | repoSpec description ]
]

{ #category : 'loading' }
MetacelloPackageSpec >> repositorySpecs [

	^self repositories map values
]

{ #category : 'private' }
MetacelloPackageSpec >> resolveToPackagesAndProjectsIn: aVersionSpec [

	^ { self }
]

{ #category : 'private' }
MetacelloPackageSpec >> resolveToPackagesIn: aVersionSpec visited: visited [

	^{ self }
]

{ #category : 'accessing' }
MetacelloPackageSpec >> workingCopy [
	"Answer a working copy, or nil if the package is not loaded."

	| wcs |
	wcs := MCWorkingCopy allWorkingCopies select: [ :each |
		       each packageName = self name ].
	wcs isEmpty ifTrue: [ ^ nil ].
	^ wcs detectMax: [ :ea | ea package name size ]
]
