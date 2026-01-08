Class {
	#name : 'MetacelloRepositoriesSpec',
	#superclass : 'MetacelloMemberListSpec',
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'actions' }
MetacelloRepositoriesSpec >> add: aStringOrSpec [

	| spec |
	spec := aStringOrSpec isString
		        ifTrue: [ MetacelloRepositorySpec description: aStringOrSpec ]
		        ifFalse: [ aStringOrSpec ].

	self addMemberForSpec: spec
]

{ #category : 'scripting' }
MetacelloRepositoriesSpec >> canUpgradeTo: aMetacelloRepositoriesSpec [

	| repositorySpecs anotherRepositorySpecs |
	repositorySpecs := self specs sort: [ :a :b | a description <= b description ].
	anotherRepositorySpecs := aMetacelloRepositoriesSpec specs sort: [ :a :b | a description <= b description ].
	repositorySpecs size = anotherRepositorySpecs size ifFalse: [ ^ false ].
	1 to: repositorySpecs size do: [ :index |
			| repoSpec anotherRepoSpec |
			repoSpec := repositorySpecs at: index.
			anotherRepoSpec := anotherRepositorySpecs at: index.
			(repoSpec canUpgradeTo: anotherRepoSpec) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : 'scripting' }
MetacelloRepositoriesSpec >> compareEqual: aMetacelloProjectSpec [

	| repositorySpecs anotherRepositorySpecs |
	repositorySpecs := (self specs sort: [ :a :b | a description <= b description ]) collect: [ :each | each description ].
	anotherRepositorySpecs := (aMetacelloProjectSpec specs sort: [ :a :b | a description <= b description ]) collect: [ :each | each description ].
	^ repositorySpecs = anotherRepositorySpecs
]

{ #category : 'scripting' }
MetacelloRepositoriesSpec >> hasNoLoadConflicts: aMetacelloRepositoriesSpec [

	| repositorySpecs anotherRepositorySpecs |
	repositorySpecs := self specs sort: [ :a :b | a description <= b description ].
	anotherRepositorySpecs := aMetacelloRepositoriesSpec specs sort: [ :a :b | a description <= b description ].
	repositorySpecs size ~= anotherRepositorySpecs size ifTrue: [ ^ false ].
	1 to: repositorySpecs size do: [ :index |
			| repoSpec anotherRepoSpec |
			repoSpec := repositorySpecs at: index.
			anotherRepoSpec := anotherRepositorySpecs at: index.
			(repoSpec hasNoLoadConflicts: anotherRepoSpec) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'actions' }
MetacelloRepositoriesSpec >> merge: aRepositorySpec [

	aRepositorySpec mergeIntoMetacelloRepositories: self
]

{ #category : 'scripting' }
MetacelloRepositoriesSpec >> metacelloRegistrationHash [
    ^ ((self map values sort: [ :a :b | a description <= b description ]) collect: [ :each | each description ]) hash
]

{ #category : 'actions' }
MetacelloRepositoriesSpec >> remove: aRepositorySpec [

	aRepositorySpec removeFromMetacelloRepositories: self
]

{ #category : 'actions' }
MetacelloRepositoriesSpec >> repository: aStringOrSpec [

	self add: aStringOrSpec
]

{ #category : 'actions' }
MetacelloRepositoriesSpec >> repository: description username: username password: password [

	| spec |
	spec := (MetacelloRepositorySpec description: description)
		        username: username;
		        password: password;
		        yourself.
	self addMemberForSpec: spec
]
