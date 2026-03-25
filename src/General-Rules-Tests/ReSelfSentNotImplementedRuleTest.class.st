"
A RBSelfSentNotImplementedRuleTest is a test class for testing the behavior of RBSelfSentNotImplementedRule
"
Class {
	#name : 'ReSelfSentNotImplementedRuleTest',
	#superclass : 'ReAbstractRuleTestCase',
	#category : 'General-Rules-Tests-Bugs',
	#package : 'General-Rules-Tests',
	#tag : 'Bugs'
}

{ #category : 'tests' }
ReSelfSentNotImplementedRuleTest >> myCritiquesOnMethod: method ast: ast [
	"The global Release tests identify sampleMethod as a violation.
	Thus, we mark it as ignoreNotImplementedSelectors:.
	However, we locally remove the pragma to be able to test that the checker does actually check"

	"TODO: Shouldn't we test that the pragma is well taken into account too?"

	| methodAST |
	methodAST := ast copy.
	methodAST removePragmaNamed: #ignoreNotImplementedSelectors:.

	^ super myCritiquesOnMethod: method ast: methodAST
]

{ #category : 'sample' }
ReSelfSentNotImplementedRuleTest >> sampleMethod [
	"Do not highlight this bar. I am a method used in testCheckForCritiques"

	self bar.
	self bar; bar.
	(2 + 5) bar.
	7 < 10 ifTrue: [ self check:7 forCritiquesDo: 9 ]
]

{ #category : 'tests' }
ReSelfSentNotImplementedRuleTest >> testRule [
	| critiques|
	critiques := self myCritiques .

	self assert: critiques size equals: 4.
	self assert: (self sourceAtChritique: critiques first) equals: 'self bar'
]
