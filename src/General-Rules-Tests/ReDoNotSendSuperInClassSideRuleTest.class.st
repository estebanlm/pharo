Class {
	#name : 'ReDoNotSendSuperInClassSideRuleTest',
	#superclass : 'ReAbstractRuleTestCase',
	#instVars : [
		'rule',
		'selector'
	],
	#category : 'General-Rules-Tests-Potential Bugs',
	#package : 'General-Rules-Tests',
	#tag : 'Potential Bugs'
}

{ #category : 'testing' }
ReDoNotSendSuperInClassSideRuleTest class >> isAbstract [

    ^ self class == ReDoNotSendSuperInClassSideRuleTest
]

{ #category : 'utilities' }
ReDoNotSendSuperInClassSideRuleTest >> generateMethod: aString [

    ^ self generateMethod: aString classified: '-' in: self class class
]

{ #category : 'utilities' }
ReDoNotSendSuperInClassSideRuleTest >> generateMethod: aString in: aClass [

    ^ self generateMethod: aString classified: '-' in: aClass
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> methodWithSuper [

    ^ self selector , ' aBoolean super ' , self selector , ' aBoolean. 2 + 2'
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> methodWithoutSuper [

    ^ self selector , ' aBoolean ' , ' 2 + 2'
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> methodWithoutSuperWrongSelector [

    ^ 'hola:' , ' aBoolean ' , ' 2 + 2'
]

{ #category : 'running' }
ReDoNotSendSuperInClassSideRuleTest >> ruleClassInstance [

    ^ self subclassResponsibility
]

{ #category : 'accessing' }
ReDoNotSendSuperInClassSideRuleTest >> selector [

    ^ self subclassResponsibility
]

{ #category : 'running' }
ReDoNotSendSuperInClassSideRuleTest >> setUp [

    super setUp.
    rule := self ruleClassInstance.
    compiledMethods := OrderedCollection new
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> testDoesNotMatch [

	self generateMethod: self methodWithoutSuper.
	self assert: (self myCritiquesOnMethod: compiledMethods first) size equals: 0
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> testRuleMatchesOnce [

	self generateMethod: self methodWithSuper.
	self assert: (self myCritiquesOnMethod: compiledMethods first) size equals: 1
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> testShouldCheckMethod [

	self generateMethod: self methodWithSuper.
	self assert: (rule shouldCheckMethod: compiledMethods first)
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> testShouldNotCheckMethodInInstanceSide [

	self generateMethod: self methodWithoutSuper in: self class.
	self deny: (rule shouldCheckMethod: compiledMethods first)
]

{ #category : 'tests' }
ReDoNotSendSuperInClassSideRuleTest >> testShouldNotCheckMethodWrongSelector [

	self generateMethod: self methodWithoutSuperWrongSelector.
	self deny: (rule shouldCheckMethod: compiledMethods first)
]
