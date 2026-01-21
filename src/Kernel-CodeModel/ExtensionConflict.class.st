Class {
	#name : 'ExtensionConflict',
	#superclass : 'Error',
	#instVars : [
		'selector',
		'conflictingClass'
	],
	#category : 'Kernel-CodeModel',
	#package : 'Kernel-CodeModel'
}

{ #category : 'as yet unclassified' }
ExtensionConflict >> conflictingClass: aClass [ 

	conflictingClass := aClass 
]

{ #category : 'accessing' }
ExtensionConflict >> messageText [

	^ 'Conflict extending #{1} in {2}' format: {
			  selector asString.
			  conflictingClass name }
]

{ #category : 'accessing' }
ExtensionConflict >> selector: aScopedSelector [ 
	
	selector := aScopedSelector
]
