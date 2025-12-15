Class {
	#name : 'BaselineOfFileSystem',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFileSystem',
	#package : 'BaselineOfFileSystem'
}

{ #category : 'accessing' }
BaselineOfFileSystem class >> corePackageNames [

	^ self packagesOfGroupNamed: #Core
]

{ #category : 'baselines' }
BaselineOfFileSystem >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'FileSystem-Path';
				package: 'FileSystem-Core';
				package: 'FileSystem-Disk'.

			spec group: 'Core' with: { 'FileSystem-Path'. 'FileSystem-Core'. 'FileSystem-Disk' } ]
]
