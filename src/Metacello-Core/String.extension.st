Extension { #name : 'String' }

{ #category : '*Metacello-Core' }
String >> addToMetacelloRepositories: aMetacelloRepositoriesSpec [

	aMetacelloRepositoriesSpec addMemberForSpec: (MetacelloRepositorySpec description: self)
]
