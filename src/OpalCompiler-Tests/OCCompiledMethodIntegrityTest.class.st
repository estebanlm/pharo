Class {
	#name : 'OCCompiledMethodIntegrityTest',
	#superclass : 'TestCase',
	#category : 'OpalCompiler-Tests-Misc',
	#package : 'OpalCompiler-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> ascentOf: aCharacter [
	
	^ [ | temp1 temp2 temp3 | 1= temp1. 2 = temp2. 3 = temp3]
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> ascentOfNoArgUsed: aCharacter [

	^ self ascent
		
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> methodDoublePragma [
	<hello: 5>
	<hello: 2>
	
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> primitiveSize [

	<primitive: 62>
	^ self basicSize
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> testBlockTemps [

	| cm |
	cm := self class >> #ascentOf:.

	self 
		assert: cm numArgs 
		equals: 1.
	self 
		assert: (cm numLiterals = 3 or: [ cm numLiterals = 4	"Sista Bytecode" ]).
	self 
		assert: cm numTemps 
		equals: 1.
	self 
		assert: cm primitive 
		equals: 0
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> testNotUsedArgument [

	| cm |
	cm := self class >> #ascentOfNoArgUsed:.

	self assert: cm numArgs equals: 1.
	self assert: cm numLiterals equals: 3.
	self assert: cm numTemps equals: 1.
	self assert: cm primitive equals: 0
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> testPragmas [

	| cm |
	cm := self class>>#methodDoublePragma.

	self assert: cm numArgs equals: 0.
	self assert: cm numLiterals equals: 2.

	"AdditionalState assertions"
	self assert: cm allLiterals first selector equals: #methodDoublePragma.
	self assert: (cm allLiterals first instVarNamed: 'method') equals: cm.

	self assert: cm primitive equals: 256
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> testPrimitive [

	| cm |
	cm := self class >> #primitiveSize.
	self assert: cm numArgs equals: 0.
	self assert: cm numLiterals equals: 3.
	self assert: cm numTemps equals: 0.
	self assert: cm primitive equals: 62
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> testRemoteTempInVector [

	| cm |
	cm := self class >> #value.

	self assert: cm numArgs equals: 0.
	self assert: cm numLiterals equals: 3.
	self assert: cm numTemps equals: 1.
	self assert: cm primitive equals: 0
]

{ #category : 'tests' }
OCCompiledMethodIntegrityTest >> value [

	| answer |
	self do: [ :each | answer := each value ].
	^ answer
]
