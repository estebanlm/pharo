Class {
	#name : 'ExtensionConflict',
	#superclass : 'Error',
	#instVars : [
		'selector',
		'conflictingClass',
		'conflictingExtensions'
	],
	#category : 'Kernel-CodeModel',
	#package : 'Kernel-CodeModel'
}

{ #category : 'accessing' }
ExtensionConflict >> conflictingClass [

	^ conflictingClass
]

{ #category : 'accessing' }
ExtensionConflict >> conflictingClass: aConflictingClass [

	conflictingClass := aConflictingClass
]

{ #category : 'accessing' }
ExtensionConflict >> conflictingExtensions [

	^ conflictingExtensions
]

{ #category : 'accessing' }
ExtensionConflict >> conflictingExtensions: anObject [

	conflictingExtensions := anObject
]

{ #category : 'initialization' }
ExtensionConflict >> initialize [

	super initialize.
	conflictingExtensions := #()
]

{ #category : 'accessing' }
ExtensionConflict >> selector [

	^ selector
]

{ #category : 'accessing' }
ExtensionConflict >> selector: aSelector [

	selector := aSelector
]
