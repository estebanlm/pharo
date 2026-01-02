Class {
	#name : 'MetacelloVersion',
	#superclass : 'Object',
	#instVars : [
		'spec',
		'versionNumber'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MetacelloVersion class >> fromSpec: aMetacelloVersionSpec [

	^ self new
		  spec: aMetacelloVersionSpec;
		  yourself
]

{ #category : 'querying' }
MetacelloVersion >> defaultPackageNamesToLoad: defaultList [
	"Answer the list of packages and projects to be loaded: packages already loaded plust defaultList"
	
	^ self packageAndProjectNamesToLoad: defaultList loader: nil
]

{ #category : 'private' }
MetacelloVersion >> doFetchRequiredFromArray: anArray withEngine: anEngine [

	^ self
		  doWithProgress: [
		  self fetchRequiredFromArray: anArray withEngine: anEngine ]
		  label: 'Fetching'
		  silently: anEngine silently
]

{ #category : 'private' }
MetacelloVersion >> doLoadRequiredFromArray: anArray withEngine: anEngine [

	^ self
		  doWithProgress: [
		  self loadRequiredFromArray: anArray withEngine: anEngine ]
		  label: 'Loading'
		  silently: anEngine silently
]

{ #category : 'private' }
MetacelloVersion >> doRecordRequiredFromArray: anArray withEngine: anEngine [

	^ self
		  doWithProgress: [
		  self recordRequiredFromArray: anArray withEngine: anEngine ]
		  label: 'Recording'
		  silently: anEngine silently
]

{ #category : 'private' }
MetacelloVersion >> doWithProgress: aBlock label: aLabel silently: silently [

	| displayString result |
	displayString := aLabel , ' baseline of ' , self spec projectLabel.
	MetacelloNotification signal: displayString , '...'.

	silently
		ifTrue: [ result := aBlock value ]
		ifFalse: [
				displayString displayProgressFrom: 0 to: 2 during: [ :bar |
						bar value: 1.
						result := aBlock value.
						bar value: 2 ] ].

	MetacelloNotification signal: '...finished to load the baseline'.
	^ result
]

{ #category : 'private' }
MetacelloVersion >> fetchRequiredFromArray: anArray withEngine: anEngine [

	| directive |
	directive := self
		              recordRequiredFromArray:
		              (self defaultPackageNamesToLoad: anArray)
		              withEngine: anEngine.

	directive acceptVisitor: (MetacelloFetchTarget on: anEngine).
	^ directive
]

{ #category : 'querying' }
MetacelloVersion >> groups [
	"Answers the list of groups associated with this version"
	
	| groups |
	groups := OrderedCollection new.
	self spec projectDo: [:ignored | ] packageDo: [:ignored | ] groupDo: [:grp | groups add: grp ].
	^groups
]

{ #category : 'private' }
MetacelloVersion >> loadRequiredFromArray: anArray withEngine: anEngine [

	| directive |
	directive := self
		             fetchRequiredFromArray:
		             (self defaultPackageNamesToLoad: anArray)
		             withEngine: anEngine.
	directive acceptVisitor: (MetacelloLoadTarget on: anEngine).
	^ directive
]

{ #category : 'actions' }
MetacelloVersion >> loadUsingTarget: aTarget withEngine: anEngine [

	^self doLoadRequiredFromArray: self spec defaultPackageNames withEngine: anEngine
]

{ #category : 'querying' }
MetacelloVersion >> loader [

	^self spec loader
]

{ #category : 'testing' }
MetacelloVersion >> name [
	"I'm probably some dead code."

	^ 'baseline'
]

{ #category : 'querying' }
MetacelloVersion >> packageAndProjectNamesToLoad: defaultList loader: aLoader [
	"Answer the list of packages and projects to be loaded: packages already loaded plust defaultList"

	defaultList isEmpty ifTrue: [ ^ self spec defaultPackageNames ].
	^ defaultList
]

{ #category : 'querying' }
MetacelloVersion >> packageNamed: aString [

	^self packageNamed: aString ifAbsent: [ ^nil ].
]

{ #category : 'querying' }
MetacelloVersion >> packageNamed: aString ifAbsent: aBlock [

	^ (self spec packageNamed: aString ifAbsent: [  ])
		  ifNil: [ aBlock value ]
		  ifNotNil: [ :pkg | pkg referencedSpec ]
]

{ #category : 'querying' }
MetacelloVersion >> packages [
	"Answers the list of packages associated with this version"

	| packages |
	packages := OrderedCollection new.
	self spec projectDo: [:ignored | ] packageDo: [:pkg | packages add: pkg ] groupDo: [:ignored | ].
	^packages
]

{ #category : 'querying' }
MetacelloVersion >> packagesForSpecNamed: aString [
	"resolves list of packages associated with the named spec.
	   If the spec is a packages, answer a list including only the package. #requires: and #includes:
			fields in the package are ignored.
	   If the spec is a project, answers an empty list.
	   If the spec is a group, answers the list of packages in the #includes: field of the group. 
			Groups in the #includes: field are expanded following the transitive closure on groups"
	"If there is no spec named <aString>, answers an empty list"

	^self packagesForSpecNamed: aString ifAbsent: [ ^#() ]
]

{ #category : 'querying' }
MetacelloVersion >> packagesForSpecNamed: aString ifAbsent: aBlock [
	"resolves list of packages associated with the named spec.
	   If the spec is a packages, answer a list including only the package. #requires: and #includes:
			fields in the package are ignored.
	   If the spec is a project, answers an empty list.
	   If the spec is a group, answers the list of packages in the #includes: field of the group. 
			Groups in the #includes: field are expanded following the transitive closure on groups"

	"If there is no spec named <aString>, aBlock is evaluated"

	^ (self spec packageNamed: aString ifAbsent: aBlock) resolveToPackagesIn: self spec visited: MetacelloVisitedPackages new
]

{ #category : 'printing' }
MetacelloVersion >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		nextPutAll: self projectLabel;
		nextPut: $]
]

{ #category : 'querying' }
MetacelloVersion >> project [

	^ self spec project
]

{ #category : 'accessing' }
MetacelloVersion >> projectLabel [

	^ self spec projectLabel
]

{ #category : 'querying' }
MetacelloVersion >> projects [
	"Answers the list of projects associated with this version"

	| projects |
	projects := OrderedCollection new.
	self spec projectDo: [:prj | projects add: prj projectReference ] packageDo: [:ignored | ] groupDo: [:ignored | ].
	^projects
]

{ #category : 'private' }
MetacelloVersion >> recordRequiredFromArray: anArray withEngine: anEngine [

	| target |
	target := MetacelloRecordTarget on: anEngine.
	target required: anArray.

	self spec acceptVisitor: target.

	^ target specBuilder root
]

{ #category : 'actions' }
MetacelloVersion >> recordWithEngine: anEngine [

	^self doRecordRequiredFromArray: self spec defaultPackageNames withEngine: anEngine
]

{ #category : 'accessing' }
MetacelloVersion >> spec [

	^spec
]

{ #category : 'accessing' }
MetacelloVersion >> spec: aMetacellVersionSpec [

	spec := aMetacellVersionSpec
]

{ #category : 'actions' }
MetacelloVersion >> unload [

	^self spec unload
]

{ #category : 'accessing' }
MetacelloVersion >> versionSpec [

	^self spec
]
