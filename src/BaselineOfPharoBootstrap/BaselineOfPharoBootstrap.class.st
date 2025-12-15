"
This baseline describes packages included in the bootstrapped Pharo image. 

It is not supposed to be part of bootstrapped image because it is dependent on Metacello.

This baseline includes several utility methods required to prepare data for the bootstrapping and initial image initialization.
"
Class {
	#name : 'BaselineOfPharoBootstrap',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoBootstrap',
	#package : 'BaselineOfPharoBootstrap'
}

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> compilerPackageNames [

	^ self packagesOfGroupNamed: #CompilerGroup
]

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> fileSystemPackageNames [

	^ self packagesOfGroupNamed: #FileSystemGroup
]

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> kernelAdditionalPackagesNames [

	^ self packagesOfGroupNamed: #AdditionalPackages
]

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> kernelPackageNames [

	^ self packagesOfGroupNamed: #KernelGroup
]

{ #category : 'traversing' }
BaselineOfPharoBootstrap class >> packagesRecursiveIn: aGroupName [

	| allMembers allPackagesInBaseline packages groups |
	allMembers := self version groups detect: [ :g | g name = aGroupName ].
	allPackagesInBaseline := self version packages collect: [ :each | each name ].
	packages := allMembers includes select: [ :aName | allPackagesInBaseline includes: aName ].
	groups := allMembers includes reject: [ :aName | allPackagesInBaseline includes: aName ].		
	^ packages , (groups flatCollect: [ :aInnerGroupName | self packagesRecursiveIn: aInnerGroupName ]).
]

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> packagesToExportWithHermes [

	^ self packagesRecursiveIn: 'ToLoadByHermes'
]

{ #category : 'accessing' }
BaselineOfPharoBootstrap class >> sUnitPackageNames [

	^ self packagesOfGroupNamed: #SUnitGroup
]

{ #category : 'baselines' }
BaselineOfPharoBootstrap >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec package: 'AST-Core'.
		spec package: 'Collections-Arithmetic'.
		spec package: 'Collections-Atomic'.
		spec package: 'Collections-Stack'.
		spec package: 'Deprecation'.
		spec package: 'FileSystem-Path'.
		spec package: 'Hermes-Extensions'.

		spec package: 'NumberParser'.
	
		spec package: 'ParseTreeRewriter'.
		
		spec package: 'UIManager'.
		
		spec package: 'CodeImport'.
		
		spec package: 'CodeImport-Commands'.
		
		spec package: 'OpalCompiler-Core'.
		spec package: 'DebugInfo'
			with: [ spec requires: #( 'OpalCompiler-Core' ) ].
		
		spec package: 'FileSystem-Core'.
		spec package: 'FileSystem-Disk'.

		spec package: 'Random-Core'.
		spec package: 'SUnit-Core'.
		spec package: 'SUnit-Tests'.
		spec package: 'Kernel-Tests'.
		spec package: 'SUnit-Basic-CLI'.		
		BaselineOfKernel corePackageNames do: [ :package | spec package: package ].
		BaselineOfKernel additionalPackagesPackageNames do: [ :package | spec package: package ].
		BaselineOfMonticello corePackageNames do: [ :package | spec package: package ].

		spec group: 'KernelGroup' with: BaselineOfKernel corePackageNames.
		
		spec group: 'AdditionalPackages' with: BaselineOfKernel additionalPackagesPackageNames.

		"These packages are added using hermes after bootstrap"

		spec group: 'CompilerGroup' with: {
			'UIManager'.
			'AST-Core'.
			'Collections-Arithmetic'.
			'Collections-Atomic'.
			'Collections-Stack'.
			'CodeImport'.
			'CodeImport-Commands'.
			'DebugInfo'.
			'NumberParser'.
			'OpalCompiler-Core'.
			'ParseTreeRewriter'.
			'Deprecation'}.
		
		spec group: 'FileSystemGroup' with: {
			'FileSystem-Path'.
			'FileSystem-Core'.
			'FileSystem-Disk'}.
			
		spec group: 'MonticelloCore' with: BaselineOfMonticello corePackageNames.

		spec group: 'ToLoadByHermes' with: {
			'AdditionalPackages'.
			'CompilerGroup'.
			'FileSystemGroup'.
			'Hermes-Extensions'.
			'MonticelloCore'.
			'SUnitGroup'.
		}.

		spec group: 'SUnitGroup' with: {
			'Deprecation'.
			'Random-Core'.
			'ParseTreeRewriter'.
			'SUnit-Core'.
			'SUnit-Tests'.
			'Kernel-Tests'.
			'SUnit-Basic-CLI'}.

	]
]
