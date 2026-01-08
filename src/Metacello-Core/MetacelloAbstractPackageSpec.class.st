Class {
	#name : 'MetacelloAbstractPackageSpec',
	#superclass : 'MetacelloSpec',
	#instVars : [
		'requires',
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

{ #category : 'private' }
MetacelloAbstractPackageSpec >> includeSpecNamesForPackageOrdering: aVersionSpec [
  ^ self specs: self includesForPackageOrdering forPackageOrdering: aVersionSpec
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
  ^ #()
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
	map at: #requires put: requires.
	map at: #includes put: includes.
	^map
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> mergeSpec: anotherSpec [

	| newSpec map |
	newSpec := super mergeSpec: anotherSpec.
	map := anotherSpec mergeMap.
	(map at: #requires) ifNotNil: [ :anotherRequires | newSpec requires: self requires , anotherRequires ].
	(map at: #includes) ifNotNil: [ :anotherIncludes | newSpec includes: self includes , anotherIncludes ].
	^ newSpec
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> name [

	^ self subclassResponsibility
]

{ #category : 'merging' }
MetacelloAbstractPackageSpec >> nonOverridable [

	^#( includes requires )
]

{ #category : 'copying' }
MetacelloAbstractPackageSpec >> postCopy [

	super postCopy.
	requires := requires copy.
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
  ^ (self requiredSpecsForPackageOrdering: aVersionSpec)
    collect: [ :spec | spec name ]
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> requiredSpecsForPackageOrdering: aVersionSpec [
  ^ self specs: self requires forPackageOrdering: aVersionSpec
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> requires [

	^ requires ifNil: [ requires := #(  ) ]
]

{ #category : 'accessing' }
MetacelloAbstractPackageSpec >> requires: aCollection [

	requires := aCollection isString
		            ifTrue: [ { aCollection } ]
		            ifFalse: [ aCollection asArray ]
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> requiresSpecsForPackageOrdering: aVersionSpec [
  ^ {self}
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveSpecsForPackageOrdering: aVersionSpec [
  ^ {self}
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveToLoadableSpec [

	^self
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> resolveToPackagesAndProjectsIn: aVersionSpec [

	^ self subclassResponsibility
]

{ #category : 'private' }
MetacelloAbstractPackageSpec >> specs: specNames forPackageOrdering: aVersionSpec [

	| packageOrProjectSpecs |
	packageOrProjectSpecs := Set new.
	specNames do: [ :specName |
			| spec |
			"get project/group/package specs"
			spec := aVersionSpec packageNamed: specName ifAbsent: [
					        MetacelloNameNotDefinedError signal:
						        'project group, or package named: ' , specName printString , ' not found when used in requires: or includes: field of package: '
						        , self name printString , ' of ' , aVersionSpec projectLabel , '.'.
					        nil "return nil if resumed" ].
			spec ifNotNil: [ packageOrProjectSpecs addAll: (spec resolveSpecsForPackageOrdering: aVersionSpec) ] ].
	^ packageOrProjectSpecs
]

{ #category : 'querying' }
MetacelloAbstractPackageSpec >> version [ 
	"MetacelloPackageSpec compatibility"
	
	^nil
]
