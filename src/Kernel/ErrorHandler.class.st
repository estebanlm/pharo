Class {
	#name : 'ErrorHandler',
	#superclass : 'Object',
	#classVars : [
		'DefaultErrorHandler'
	],
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
ErrorHandler class >> defaultErrorHandler [

	^ DefaultErrorHandler ifNil: [ self ]
]

{ #category : 'accessing' }
ErrorHandler class >> defaultErrorHandler: anErrorHandler [

	DefaultErrorHandler := anErrorHandler
]
