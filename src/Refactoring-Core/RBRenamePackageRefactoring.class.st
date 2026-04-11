"
I'm a refactoring to rename a package.

My preconditions verify that the new name is different from the current package name and is a valid name.

I change all the references of the classes that are defined within the package, and if there is a manifest, it is updated with the new name of the package. 

Example
---------
```
(RBRenamePackageRefactoring 
				rename: (self getPackageNamed: #'Refactoring-Tests-Core')
				to: #'Refactoring-Core-Test') execute.
```
"
Class {
	#name : 'RBRenamePackageRefactoring',
	#superclass : 'RBPackageRefactoring',
	#instVars : [
		'package'
	],
	#category : 'Refactoring-Core-Refactorings',
	#package : 'Refactoring-Core',
	#tag : 'Refactorings'
}

{ #category : 'instance creation' }
RBRenamePackageRefactoring class >> model: aRBSmalltalk rename: aSymbol to: aNewName [
	^ self new
		model: aRBSmalltalk;
		packageName: aSymbol newName: aNewName;
		yourself
]

{ #category : 'instance creation' }
RBRenamePackageRefactoring class >> rename: aString to: aNewName [
	^ self new
		packageName: aString newName: aNewName
]

{ #category : 'preconditions' }
RBRenamePackageRefactoring >> applicabilityPreconditions [

    ^ super applicabilityPreconditions,
        {
            (RePackageNamesAreDifferentCondition new
                packageName: packageName;
                newName: newName).
				self preconditionTargetPackageNotExist
        }
]

{ #category : 'transforming' }
RBRenamePackageRefactoring >> manifestClassNameFor: aPackageName [
	"Returns a symbol representing a suitable name for a Manifest class for the given package"

	^('Manifest', (aPackageName select: [:each | each isAlphaNumeric ])) asSymbol
]

{ #category : 'class management' }
ReRenamePackageRefactoring >> newName: aNewName [
    newName := aNewName
]

{ #category : 'initialization' }
RBRenamePackageRefactoring >> packageName: aName newName: aNewName [
	packageName := aName asSymbol.
	newName := aNewName asSymbol
]

{ #category : 'preconditions' }
ReRenamePackageRefactoring >> preconditionTargetPackageNotExist [  
    ^ (RePackageExistsCondition 
        new
        packageName: newName;
        packageOrganizer: self packageOrganizer) not
]

{ #category : 'transforming' }
RBRenamePackageRefactoring >> prepareForExecution [
    package := self model packageNamed: packageName
]

{ #category : 'transforming' }
RBRenamePackageRefactoring >> privateTransform [

	self renamePackage.
	self renameManifestClass
]

{ #category : 'class management' }
ReRenamePackageRefactoring >> rename: aName [
    packageName := aName
]

{ #category : 'transforming' }
RBRenamePackageRefactoring >> renameManifestClass [
	|refactoring manifest|
	manifest := package realPackage packageManifestOrNil.
	manifest ifNotNil: [
	refactoring := ReRenameClassRefactoring
		model: self model
		rename: manifest name
		to: (self manifestClassNameFor: newName).
	self generateChangesFor: refactoring]
]

{ #category : 'transforming' }
RBRenamePackageRefactoring >> renamePackage [
	self model renamePackage: package to: newName
]
