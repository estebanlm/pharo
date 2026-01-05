Extension { #name : 'Collection' }

{ #category : '*Metacello-Core' }
Collection >> addToMetacelloRepositories: aMetacelloRepositoriesSpec [

	self do: [:each | each addToMetacelloRepositories: aMetacelloRepositoriesSpec ]
]
