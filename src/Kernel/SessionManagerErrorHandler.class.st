Class {
	#name : 'SessionManagerErrorHandler',
	#superclass : 'NonInteractiveErrorHandler',
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'testing' }
SessionManagerErrorHandler class >> isValidForCurrentSystemConfiguration [

	^ false
]

{ #category : 'error handling' }
SessionManagerErrorHandler >> handleError: anError log: shouldLog [
	"We should log only the first time that the error is handled. Then, the deferred startup action never asks to log: either we never were asked to log (shouldLog=true) or we logged in the super send."

	(anError isKindOf: Notification)
		ifTrue: [ anError resume ]
		ifFalse: [
			anError freeze.
			self sessionManager addDeferredStartupAction: [
				self uiManager handleError: anError log: false ] ]
]

{ #category : 'accessing' }
SessionManagerErrorHandler >> sessionManager [
	^ SessionManager default
]
