Class {
	#name : 'MetacelloSpecTestCase',
	#superclass : 'TestCase',
	#category : 'Metacello-TestsCore-Specs',
	#package : 'Metacello-TestsCore',
	#tag : 'Specs'
}

{ #category : 'specs' }
MetacelloSpecTestCase >> groupSpec [
    ^ self project groupSpec
]

{ #category : 'accessing' }
MetacelloSpecTestCase >> packageSpec [

	^ self project packageSpec
]

{ #category : 'specs' }
MetacelloSpecTestCase >> packagesSpec [

	^ MetacelloPackagesSpec new
]

{ #category : 'accessing' }
MetacelloSpecTestCase >> project [

	^ (MetacelloStubConstructor on: self) project
]

{ #category : 'specs' }
MetacelloSpecTestCase >> projectReferenceSpec [

	^ MetacelloProjectReferenceSpec new
]

{ #category : 'specs' }
MetacelloSpecTestCase >> projectSpec [

	^ MetacelloProjectSpec project: self project
]

{ #category : 'accessing' }
MetacelloSpecTestCase >> repositoriesSpec [

	^ MetacelloRepositoriesSpec new
]

{ #category : 'accessing' }
MetacelloSpecTestCase >> repositorySpec [

	^ MetacelloRepositorySpec new
]

{ #category : 'specs' }
MetacelloSpecTestCase >> versionSpec [

	^ MetacelloVersionSpec project: self project
]
