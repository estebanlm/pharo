Class {
	#name : 'BytecodeDebugInfo',
	#superclass : 'Object',
	#instVars : [
		'method'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
BytecodeDebugInfo class >> on: aMethod [

	^ self new
		method: aMethod;
		yourself
]

{ #category : 'testing' }
BytecodeDebugInfo >> isSourceReturn: aBytecodePC [

	^ true
]

{ #category : 'testing' }
BytecodeDebugInfo >> isSourceSend: aBytecodePC [

	^ true
]

{ #category : 'testing' }
BytecodeDebugInfo >> isSourceStore: aBytecodePC [
	
	^ true
]

{ #category : 'accessing' }
BytecodeDebugInfo >> method: aMethod [

	method := aMethod
]

{ #category : 'accessing' }
BytecodeDebugInfo >> rangeForPC: aPC [

	| rangeStart |
	rangeStart := 1.
	self sourceCode linesDo: [ :line |
		(line beginsWith: aPC asString)
			ifTrue: [ 
				"-1 to ignore the line ending"
				^ rangeStart to: rangeStart + line size - 1 ].
		"+1 to skip the line ending"
		rangeStart := rangeStart + line size + 1 ].
	^ self error: 'Cannot find range for pc: ', aPC asString
]

{ #category : 'accessing' }
BytecodeDebugInfo >> shouldStopAt: aBytecodePC [

	^ true
]

{ #category : 'accessing' }
BytecodeDebugInfo >> sourceCode [

	^ String streamContents: [ :aStream |
		  (SymbolicBytecodeBuilder decode: method)
			  do: [ :each | each printOn: aStream ]
			  separatedBy: [ aStream cr ] ]
]

{ #category : 'accessing' }
BytecodeDebugInfo >> variablesAt: aBytecodePC [

	^ (1 to: method numTemps - method numArgs) collect: [ :e |
		  RawTemporaryVariable index: e ]
]
