Class {
	#name : 'RawTemporaryVariable',
	#superclass : 'Object',
	#instVars : [
		'index'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'accessing' }
RawTemporaryVariable class >> index: anIndex [

	^ self new
		index: anIndex;
		yourself
]

{ #category : 'accessing' }
RawTemporaryVariable >> index: anIndex [

	index := anIndex
]

{ #category : 'testing' }
RawTemporaryVariable >> isArgumentVariable [

	^ false
]

{ #category : 'accessing' }
RawTemporaryVariable >> isTempVariable [

	^ true
]

{ #category : 'accessing' }
RawTemporaryVariable >> name [

	^ 'temp', index asString
]

{ #category : 'debugging' }
RawTemporaryVariable >> readInContext: aContext [
	
	^ aContext tempAt: index
]

{ #category : 'accessing' }
RawTemporaryVariable >> variableTag [
	^ 'temp. var'
]
