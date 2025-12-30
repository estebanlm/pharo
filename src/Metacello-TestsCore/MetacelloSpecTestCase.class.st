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

	^ MetacelloPackagesSpec for: self project
]

{ #category : 'accessing' }
MetacelloSpecTestCase >> project [

	^ (MetacelloStubConstructor on: self) project
]

{ #category : 'specs' }
MetacelloSpecTestCase >> projectReferenceSpec [
    ^ self project projectReferenceSpec
]

{ #category : 'specs' }
MetacelloSpecTestCase >> projectSpec [
    ^ self project projectSpec
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

	^ MetacelloVersionSpec for: self project
]
