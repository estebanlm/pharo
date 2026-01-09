Class {
	#name : 'MetacelloGroupSpec',
	#superclass : 'MetacelloAbstractPackageSpec',
	#instVars : [
		'project',
		'name'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MetacelloGroupSpec class >> project: aMetacelloProject [

	^ self new
		  project: aMetacelloProject;
		  yourself
]

{ #category : 'visiting' }
MetacelloGroupSpec >> acceptVisitor: aVisitor [ 
	
	^ aVisitor visitGroupSpec: self
]

{ #category : 'private' }
MetacelloGroupSpec >> includeSpecNamesForPackageOrdering: aVersionSpec [
  ^ #()
]

{ #category : 'merging' }
MetacelloGroupSpec >> mergeSpec: anotherSpec [

	| newSpec |
	newSpec := super mergeSpec: anotherSpec.
	anotherSpec name ifNotNil: [ :aName | newSpec name: aName ].
	^ newSpec
]

{ #category : 'querying' }
MetacelloGroupSpec >> name [

	^name
]

{ #category : 'accessing' }
MetacelloGroupSpec >> name: aString [

	name := aString trim
]

{ #category : 'loading' }
MetacelloGroupSpec >> packageSpecsInLoadOrder [

	^ (self project version spec packageSpecsInLoadOrder select: [ :each |
		   self includes includes: each name ]) flatCollect: [ :e |
		  e packageSpecsInLoadOrder ]
]

{ #category : 'accessing' }
MetacelloGroupSpec >> project [

	^ project
]

{ #category : 'accessing' }
MetacelloGroupSpec >> project: aMetacelloProject [

	project := aMetacelloProject
]

{ #category : 'visiting' }
MetacelloGroupSpec >> projectDo: projectBlock packageDo: packageBlock groupDo: groupBlock [

	groupBlock value: self
]

{ #category : 'private' }
MetacelloGroupSpec >> resolveSpecsForPackageOrdering: aVersionSpec [
	"expand the names in the group to a package or project"

	| packageOrProjectSpecs |
	packageOrProjectSpecs := Set new.
	self includes do: [ :specName |
		(aVersionSpec packageNamed: specName ifAbsent: [ ]) ifNotNil: [ :pkgSpec |
			packageOrProjectSpecs addAll: (pkgSpec resolveToPackagesAndProjectsIn: aVersionSpec) ] ].
	^ packageOrProjectSpecs
]

{ #category : 'private' }
MetacelloGroupSpec >> resolveToLoadableSpec [

	^nil
]

{ #category : 'private' }
MetacelloGroupSpec >> resolveToPackagesAndProjectsIn: aVersionSpec [

	^ self resolveToPackagesIn: aVersionSpec into: OrderedCollection new visited: OrderedCollection new
]

{ #category : 'private' }
MetacelloGroupSpec >> resolveToPackagesIn: aVersionSpec into: packages visited: visited [

	(visited includes: self name) ifTrue: [ ^ self ].

	self includes do: [ :pkgName |
			(aVersionSpec packageNamed: pkgName)
				projectDo: [ :prj | packages add: prj ]
				packageDo: [ :pkg | packages add: pkg ]
				groupDo: [ :grp | grp resolveToPackagesIn: aVersionSpec into: packages visited: visited ] ].

	^ packages
]
