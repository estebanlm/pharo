Class {
	#name : 'InteractiveErrorHandler',
	#superclass : 'ErrorHandler',
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'testing' }
InteractiveErrorHandler class >> isValidForCurrentSystemConfiguration [

	^ Smalltalk isInteractive
]
