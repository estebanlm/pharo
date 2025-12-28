"
The **MetacelloMCBaselineProject**  is a wrapper for the **BaselineOf** version specification for file-based repositories.

There is a single version in a **MetacelloMCBaselineProject**, named *'baseline'*.

A typical **BaselineOf** is specification:

```Smalltalk
baseline: spec
    <baseline>
    spec
        package: 'External-Core';
        package: 'External-Tests' with: [ spec requires: 'External-Core' ];
        yourself.
    spec
        group: 'Core' with: #('External-Core');
        group: 'default' with: #('Core');
        group: 'Tests' with: #('External-Tests');
        yourself
```

The `<baseline>` pragma marks the method containing the baseline specification.
"
Class {
	#name : 'MetacelloProject',
	#superclass : 'Object',
	#instVars : [
		'repositoryDescription',
		'versionNumberClass',
		'loadType',
		'projectAttributes',
		'versionMap',
		'configuration'
	],
	#category : 'Metacello-Core-Model',
	#package : 'Metacello-Core',
	#tag : 'Model'
}

{ #category : 'class initialization' }
MetacelloProject class >> initialize [
	"Deprecation added during the development of Pharo 14."

	self deprecatedAliases: #( #MetacelloMCBaselineProject #MetacelloBaselineProject #MetacelloCypressBaselineProject )
]

{ #category : 'instance creation' }
MetacelloProject class >> new [

	| inst |
	inst := self basicNew.
	^inst configuration: inst; yourself
]

{ #category : 'instance creation' }
MetacelloProject class >> on: aConfig [

	^self basicNew configuration: aConfig; yourself
]

{ #category : 'accessing' }
MetacelloProject class >> singletonVersionName [
    ^ 'baseline'
]

{ #category : 'scripting' }
MetacelloProject >> asConfigurationProject [
    ^ self
]

{ #category : 'private' }
MetacelloProject >> attributes [

	^ (OrderedCollection with: #common)
		  addAll: self platformAttributes;
		  yourself
]

{ #category : 'spec classes' }
MetacelloProject >> baselineOfProjectSpec [
    ^ self baselineOfProjectSpecClass for: self
]

{ #category : 'spec classes' }
MetacelloProject >> baselineOfProjectSpecClass [
    ^ MetacelloBaselineOfProjectSpec
]

{ #category : 'accessing' }
MetacelloProject >> configuration [
	^ configuration
]

{ #category : 'accessing' }
MetacelloProject >> configuration: anObject [
	configuration := anObject
]

{ #category : 'private' }
MetacelloProject >> defaultPlatformAttributes [
	"Returns the tags for the conditional platform loading in Metacello. Pay attention the order is important: from most  to least general."

	^ {
		  #squeakCommon.
		  #pharo.
		  ('pharo' , SystemVersion current major asString , '.x') asSymbol.
		  ('pharo' , SystemVersion current major asString , '.0.x') asSymbol }
]

{ #category : 'spec classes' }
MetacelloProject >> groupSpec [

	^ MetacelloGroupSpec for: self
]

{ #category : 'accessing' }
MetacelloProject >> label [

	^self configuration class name
]

{ #category : 'accessing' }
MetacelloProject >> loadType [
	"#atomic or #linear"

	^ loadType
]

{ #category : 'accessing' }
MetacelloProject >> loadType: aSymbol [
	"#atomic or #linear"

	loadType := aSymbol
]

{ #category : 'private' }
MetacelloProject >> lookupVersion: aVersionString ifAbsent: aBlock [
	"please use version:...this is a private method"

	^ self map at: aVersionString ifAbsent: [ ^ aBlock value ]
]

{ #category : 'accessing' }
MetacelloProject >> map [
	versionMap ifNil: [ ^ Dictionary new ].
	^ versionMap
]

{ #category : 'accessing' }
MetacelloProject >> map: aDictionary [

	versionMap := aDictionary
]

{ #category : 'spec classes' }
MetacelloProject >> packageSpec [

	^ MetacelloPackageSpec for: self
]

{ #category : 'spec classes' }
MetacelloProject >> packagesSpec [

	^ MetacelloPackagesSpec for: self
]

{ #category : 'private' }
MetacelloProject >> platformAttributes [

	 ^self projectPlatformAttributes
]

{ #category : 'private' }
MetacelloProject >> pragmaKeywords [

	^#(version:attribute: blessing:attribute: description:attribute: required:attribute: groups:attribute: doits:attribute: projectPackage:attribute: packages:attribute: repositories:attribute: )
]

{ #category : 'printing' }
MetacelloProject >> printOn: aStream [

	| label |
	self configuration class printOn: aStream.
	aStream nextPut: $(.
	self versions do: [ :vrsn |
		aStream nextPutAll: vrsn versionString.
		vrsn spec ifNotNil: [ (label := vrsn spec projectLabel) isEmpty ifFalse: [ aStream nextPutAll: ' [' , label , ']' ] ].
		aStream
			nextPut: $,;
			space ].
	aStream nextPut: $)
]

{ #category : 'accessing' }
MetacelloProject >> project [

	^self
]

{ #category : 'private' }
MetacelloProject >> projectAttributes [

	^ projectAttributes ifNil: [ #(  ) ]
]

{ #category : 'private' }
MetacelloProject >> projectAttributes: aList [

	projectAttributes := aList
]

{ #category : 'development support' }
MetacelloProject >> projectPackage [

	self configuration class mcWorkingCopy ifNotNil: [ :workingCopy |
		| pkgSpec repo |
		pkgSpec := self packageSpec
			           name: workingCopy packageName;
			           yourself.
		repo := workingCopy repositoryGroup repositories
			        detect: [ :each | each ~~ MCCacheRepository default ]
			        ifNone: [
				        MetacelloNotification signal: 'Using cache repository for ' , self label , ' project package'.
				        MCCacheRepository default ].
		pkgSpec repository: (repo asRepositorySpecFor: self).
		^ pkgSpec ].
	^ nil
]

{ #category : 'private' }
MetacelloProject >> projectPlatformAttributes [

	| list aBlock |
	list := OrderedCollection new.
	(aBlock := self projectAttributes) ifNotNil: [ list addAll: aBlock value ].
	^ self defaultPlatformAttributes , list
]

{ #category : 'spec classes' }
MetacelloProject >> projectReferenceSpec [

	^ MetacelloProjectReferenceSpec for: self
]

{ #category : 'spec classes' }
MetacelloProject >> projectSpec [

	^ MetacelloNamelessProjectSpec for: self
]

{ #category : 'spec classes' }
MetacelloProject >> repositoriesSpec [

	^ MetacelloRepositoriesSpec for: self
]

{ #category : 'accessing' }
MetacelloProject >> repositoryDescription [
	^ repositoryDescription
]

{ #category : 'spec classes' }
MetacelloProject >> repositorySpec [

	^ MetacelloRepositorySpec for: self
]

{ #category : 'development support' }
MetacelloProject >> setBaselineRepositoryDescription: aListOrRepositoryDescriptions [
	"set #version repositories to < aListOrRepositoryDescriptions>. Should be the directory where the BaselineOf is located."

	repositoryDescription := aListOrRepositoryDescriptions
]

{ #category : 'versions' }
MetacelloProject >> singletonVersionName [
    ^ self class singletonVersionName
]

{ #category : 'versions' }
MetacelloProject >> version [
    ^ self version: self singletonVersionName
]

{ #category : 'versions' }
MetacelloProject >> version: aVersionString [

	^ self lookupVersion: aVersionString ifAbsent: [ (MetacelloVersionDoesNotExistError project: self project versionString: aVersionString) signal ]
]

{ #category : 'versions' }
MetacelloProject >> versionNumberClass [

	^ versionNumberClass ifNil: [ versionNumberClass := MetacelloVersionNumber ]
]

{ #category : 'versions' }
MetacelloProject >> versionNumberClass: aClass [
    versionNumberClass := aClass
]

{ #category : 'spec classes' }
MetacelloProject >> versionSpec [

	^ MetacelloVersionSpec for: self
]

{ #category : 'versions' }
MetacelloProject >> versions [
  ^ [ {(self version)} ]
    on: MetacelloVersionDoesNotExistError
    do: [ :ex | ^ #() ]
]
