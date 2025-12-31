Extension { #name : 'String' }

{ #category : '*Metacello-Core' }
String >> addToMetacelloRepositories: aMetacelloRepositoriesSpec [

	aMetacelloRepositoriesSpec addMemberForSpec: (MetacelloRepositorySpec description: self)
]

{ #category : '*Metacello-Core' }
String >> asMetacelloVersionNumber [

	^MetacelloVersionNumber fromString: self
]

{ #category : '*Metacello-Core' }
String >> mergeIntoMetacelloRepositories: aMetacelloRepositoriesSpec [

	aMetacelloRepositoriesSpec mergeMemberForSpec: (MetacelloRepositorySpec description: self)
]

{ #category : '*Metacello-Core-version comparison' }
String >> metacelloIntegerLessThanSelf: anInteger [
	"integer version components are always '>' string component"

	^false
]

{ #category : '*Metacello-Core-version comparison' }
String >> metacelloStringLessThanSelf: aString [

	^aString < self
]

{ #category : '*Metacello-Core-version comparison' }
String >> metacelloVersionComponentLessThan: aMetacelloVersonComponent [

	^aMetacelloVersonComponent metacelloStringLessThanSelf: self
]

{ #category : '*Metacello-Core' }
String >> removeFromMetacelloPackages: aMetacelloPackagesSpec [

	aMetacelloPackagesSpec removeMemberNamed: self
]

{ #category : '*Metacello-Core' }
String >> removeFromMetacelloRepositories: aMetacelloRepositoriesSpec [

	aMetacelloRepositoriesSpec removeMemberNamed: self
]

{ #category : '*Metacello-Core' }
String >> setIncludesInMetacelloPackage: aMetacelloPackageSpec [

	aMetacelloPackageSpec setIncludes: { self }
]

{ #category : '*Metacello-Core' }
String >> setLoadsInMetacelloProject: aMetacelloPackageSpec [

	aMetacelloPackageSpec setLoads: { self }.
]

{ #category : '*Metacello-Core' }
String >> setRequiresInMetacelloPackage: aMetacelloPackageSpec [

	aMetacelloPackageSpec setRequires: { self }.
]
