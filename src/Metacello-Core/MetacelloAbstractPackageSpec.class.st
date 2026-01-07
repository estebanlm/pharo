Class {
	#name : 'MetacelloAbstractPackageSpec',
	#superclass : 'MetacelloSpec',
	#instVars : [
		'includes'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'testing' }
MetacelloAbstractPackageSpec class >> isAbstract [

	^ self = MetacelloAbstractPackageSpec
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> includes [

	^ includes ifNil: [ includes := #(  ) ]
]

{ #category : 'accessing' }
MetacelloAbstractPackageSpec >> includes: aCollection [

	includes := aCollection isString
		            ifTrue: [ { aCollection } ]
		            ifFalse: [ aCollection asArray ]
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> includesForPackageOrdering [

	^ #(  )
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> isPackageLoaded [

	^ false
]

{ #category : 'printing' }
MetacelloAbstractPackageSpec >> label [

	^self name
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> mergeIntoMetacelloPackages: aMetacelloPackagesSpec [

	aMetacelloPackagesSpec mergeMemberForSpec: self
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> mergeMap [

	| map |
	map := super mergeMap.
	map at: #includes put: includes.
	^ map
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> mergeSpec: anotherSpec [

	| newSpec map |
	newSpec := super mergeSpec: anotherSpec.
	map := anotherSpec mergeMap.
	(map at: #includes) ifNotNil: [ :anotherIncludes | newSpec includes: self includes , anotherIncludes ].
	^ newSpec
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> name [

	^ self subclassResponsibility
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> nonOverridable [

	^ #( includes )
]

{ #category : 'copying' }
MetacelloAbstractPackageSpec >> postCopy [

	super postCopy.
	includes := includes copy
]

{ #category : 'printing' }
MetacelloAbstractPackageSpec >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		nextPutAll: self name;
		nextPutAll: ']'
]

{ #category : 'visiting' }
MetacelloAbstractPackageSpec >> projectDo: projectBlock packageDo: packageBlock groupDo: groupBlock [

	self subclassResponsibility
]

{ #category : 'accessing' }
MetacelloAbstractPackageSpec >> referencedSpec [

	^self
]

{ #category : 'removing' }
MetacelloAbstractPackageSpec >> removeFromMetacelloPackages: aMetacelloPackagesSpec [

	aMetacelloPackagesSpec removeMemberForSpec: self
]

{ #category : 'loading' }
MetacelloAbstractPackageSpec >> repositorySpecs [

	^#()
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> requiredSpecNamesForPackageOrdering: aVersionSpec [

	^ #(  )
]

{ #category : 'testing' }
MetacelloAbstractPackageSpec >> requires [

	^ #(  )
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveSpecsForPackageOrdering: aVersionSpec [

	^ { self }
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveToLoadableSpec [

	^self
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveToPackagesAndProjectsIn: aVersionSpec [

	^ self subclassResponsibility
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> version [ 
	"MetacelloPackageSpec compatibility"
	
	^nil
]
