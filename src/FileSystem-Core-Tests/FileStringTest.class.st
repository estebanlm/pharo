Class {
	#name : 'FileStringTest',
	#superclass : 'TestCase',
	#category : 'FileSystem-Core-Tests',
	#package : 'FileSystem-Core-Tests'
}

{ #category : 'tests' }
FileStringTest >> testAsFileLocatorOrReferenceReturnsALocatorWhenStringRefersToAKnownOrigin [
	| pathString locator |
	pathString := (FileLocator home / 'foo') fullName.

	locator := pathString asFileLocatorOrReference.

	self
		assert: locator origin
		equals: #home.
	self
		assert: locator fullName
		equals: pathString
]

{ #category : 'tests' }
FileStringTest >> testAsFileLocatorOrReferenceReturnsAReferenceWhenStringDoesNotReferToAKnownOrigin [
	| fileRef result |
	fileRef := '/foo' asFileReference.

	result := fileRef fullName asFileLocatorOrReference.

	self
		assert: result
		equals: fileRef
]
