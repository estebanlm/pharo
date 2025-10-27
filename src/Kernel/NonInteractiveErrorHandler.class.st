Class {
	#name : 'NonInteractiveErrorHandler',
	#superclass : 'ErrorHandler',
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'testing' }
NonInteractiveErrorHandler class >> isValidForCurrentSystemConfiguration [

	^ Smalltalk isInteractive not
]
