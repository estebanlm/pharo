Class {
	#name : 'ErrorHandler',
	#superclass : 'Object',
	#classVars : [
		'Default',
		'DefaultErrorHandler'
	],
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
ErrorHandler class >> default [
	^ Default
		"ifNil: [
			""Note: The way the following is phrased ensures that you can always make 'more specific' managers merely by subclassing a tool builder and implementing a more specific way of reacting to #isActiveManager. For example, a BobsUIManager can subclass MorphicUIManager and will be considered before the parent (generic MorphicUIManager).""
			self allSubclasses
				detect: [ :any | any isActiveManager and: [ any subclasses noneSatisfy: [ :sub | sub isActiveManager ] ] ]
				ifFound: [ :mgrClass | Default := mgrClass new ].
			Default ]"
]

{ #category : 'accessing' }
ErrorHandler class >> default: anErrorManager [

	Stdio stdout
		nextPutAll: 'New ErrorManager ' , anErrorManager printString , ' replacing ' , Default printString;
		lf.
	Default := anErrorManager
]

{ #category : 'accessing' }
ErrorHandler class >> defaultErrorHandler [

	^ DefaultErrorHandler ifNil: [ self ]
]

{ #category : 'accessing' }
ErrorHandler class >> defaultErrorHandler: anErrorHandler [

	DefaultErrorHandler := anErrorHandler
]

{ #category : 'error handling' }
ErrorHandler >> handleError: anError [

	self handleError: anError log: true
]
