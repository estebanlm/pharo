Class {
	#name : 'RePushUpInstanceVariableAndRemoveTempChoice',
	#superclass : 'ReVariableChoice',
	#category : 'Refactoring-UI-Choices',
	#package : 'Refactoring-UI',
	#tag : 'Choices'
}

{ #category : 'accessing' }
RePushUpInstanceVariableAndRemoveTempChoice >> action [ 

	driver pushUpInstanceVariableAndRemoveTemp 
]

{ #category : 'accessing' }
RePushUpInstanceVariableAndRemoveTempChoice >> description [

	^ 'Push up instance variable from subclass and remove temporary variable'
]
