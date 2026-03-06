"
A ReDoNotSendSuperStartUpInClassSideRuleTest is a test class for testing the behavior of ReDoNotSendSuperStartUpInClassSideRule
"
Class {
	#name : 'ReDoNotSendSuperShutDownInClassSideRuleTest',
	#superclass : 'ReDoNotSendSuperInClassSideRuleTest',
	#category : 'General-Rules-Tests-Potential Bugs',
	#package : 'General-Rules-Tests',
	#tag : 'Potential Bugs'
}

{ #category : 'as yet unclassified' }
ReDoNotSendSuperShutDownInClassSideRuleTest >> ruleClassInstance [

    ^ ReDoNotSendSuperShutDownInClassSideRule new
]

{ #category : 'as yet unclassified' }
ReDoNotSendSuperShutDownInClassSideRuleTest >> selector [

    ^ #shutDown:
]
