"
""Cyril: I am not sure we should use #packageOrganizer. Maybe we should ask the environment the package manager. But currently the image does not know yet how to work with multiple package managers/modules.""
"
Class {
	#name : 'RePackageCondition',
	#superclass : 'RBNewAbstractCondition',
	#instVars : [
		'violator',
		'packageOrganizer',
		'overrideMessage'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'accessing' }
RePackageCondition >> overrideMessage: aString [
    overrideMessage := aString
]

{ #category : 'accessing' }
RePackageCondition >> packageOrganizer [
    ^ packageOrganizer
]

{ #category : 'accessing' }
RePackageCondition >> packageOrganizer: anOrganizer [
    packageOrganizer := anOrganizer
]

{ #category : 'accessing' }
RePackageCondition >> violators [
    ^ self check
        ifFalse: [ { violator } ]
        ifTrue: [ #() ]
]
