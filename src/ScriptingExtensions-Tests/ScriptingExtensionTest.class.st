Class {
	#name : 'ScriptingExtensionTest',
	#superclass : 'TestCase',
	#category : 'ScriptingExtensions-Tests',
	#package : 'ScriptingExtensions-Tests'
}

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testStringAsClassIfAbsent [

	self
		assert: ('String' asClassIfAbsent: [ self fail ])
		equals: String.

	'+' asClassIfAbsent: [ ^ self "success" ].
	self fail
]

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testStringAsClassIfPresent [

	'String' asClassIfPresent: [ :class |
		self assert: class equals: String ].

	'+' asClassIfPresent: [ ^ self fail ]
]

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testStringAsClassInEnvironment [

	self
		assert: ('String' asClassInEnvironment: self class environment)
		equals: String
]

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testSymbolAsClassIfAbsent [

	self
		assert: (#Symbol asClassIfAbsent: [ self fail ])
		equals: Symbol.

	#+ asClassIfAbsent: [ ^ self "success" ].
	self fail
]

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testSymbolAsClassIfPresent [

	#Symbol asClassIfPresent: [ :class |
		self assert: class equals: Symbol ].

	#'+' asClassIfPresent: [ ^ self fail ]
]

{ #category : 'as yet unclassified' }
ScriptingExtensionTest >> testSymbolAsClassInEnvironment [

	self
		assert: (#Symbol asClassInEnvironment: self class environment)
		equals: Symbol
]
