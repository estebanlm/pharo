"
A ReDoNotSendSuperStartUpInClassSideRuleTest is a test class for testing the behavior of ReDoNotSendSuperStartUpInClassSideRule
"
Class {
	#name : 'ReDoNotSendSuperStartUpInClassSideRuleTest',
	#superclass : 'ReDoNotSendSuperInClassSideRuleTest',
	#category : 'General-Rules-Tests-Potential Bugs',
	#package : 'General-Rules-Tests',
	#tag : 'Potential Bugs'
}

{ #category : 'as yet unclassified' }
ReDoNotSendSuperStartUpInClassSideRuleTest >> ruleClassInstance [

    ^ ReDoNotSendSuperStartUpInClassSideRule new
]

{ #category : 'as yet unclassified' }
ReDoNotSendSuperStartUpInClassSideRuleTest >> selector [

    ^ #startUp:
]
