Class {
	#name : 'OCCompilationError',
	#superclass : 'Error',
	#instVars : [
		'compilationResult'
	],
	#category : 'OpalCompiler-Core-Exceptions',
	#package : 'OpalCompiler-Core',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
OCCompilationError >> compilationResult [

	^ compilationResult
]

{ #category : 'accessing' }
OCCompilationError >> compilationResult: anObject [

	compilationResult := anObject
]

{ #category : 'initialization' }
OCCompilationError >> initialize [

	super initialize.
	messageText := 'Error while compiling'
]
