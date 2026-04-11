Class {
	#name : 'RePackageExistsCondition',
	#superclass : 'RePackageCondition',
	#instVars : [
		'packageName'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'checking' }
RePackageExistsCondition >> check [
    (packageOrganizer hasPackage: packageName ) ifFalse: [
        violator := packageName .
        ^ false ].
    ^ true
]

{ #category : 'accessing' }
RePackageExistsCondition >> errorString [
    self check
        ifTrue: [ ^ self negatedErrorString ].
    ^ 'The package ', packageName, ' does not exist in the system'
]

{ #category : 'accessing' }
RePackageExistsCondition >> negatedErrorString [
    ^ 'The package ', packageName, ' already exists in the system'
]

{ #category : 'accessing' }
RePackageExistsCondition >> packageName: aName [
    packageName := aName
]

{ #category : 'displaying' }
RePackageExistsCondition >> violationMessageOn: aStream [
    aStream
        nextPutAll: 'The package ';
        nextPutAll: violator;
        nextPutAll: ' does not exist in the system';
        nextPut: Character cr
]
