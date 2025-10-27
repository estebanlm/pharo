Class {
	#name : 'TestSessionManagerErrorHandler',
	#superclass : 'SessionManagerErrorHandler',
	#instVars : [
		'sessionManager'
	],
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
TestSessionManagerErrorHandler >> sessionManager [

	^ sessionManager
]

{ #category : 'accessing' }
TestSessionManagerErrorHandler >> sessionManager: anObject [

	sessionManager := anObject
]
