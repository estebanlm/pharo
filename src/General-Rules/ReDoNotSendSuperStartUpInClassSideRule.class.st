"
Don't send super startUp: in class side because the state level is independent from all the subclasses. This is the same issue as calling super initialize in the CLASS side.
"
Class {
	#name : 'ReDoNotSendSuperStartUpInClassSideRule',
	#superclass : 'ReNodeRewriteRule',
	#category : 'General-Rules-Potential Bugs',
	#package : 'General-Rules',
	#tag : 'Potential Bugs'
}

{ #category : 'accessing' }
ReDoNotSendSuperStartUpInClassSideRule class >> group [
	^ self potentialBugsGroup
]

{ #category : 'accessing' }
ReDoNotSendSuperStartUpInClassSideRule class >> ruleName [

    ^ 'Class-side #startUp: should not send "super startUp: arg".'
]

{ #category : 'manifest' }
ReDoNotSendSuperStartUpInClassSideRule class >> uniqueIdentifierName [

    ^ 'ReDoNotSendSuperStartUpInClassSideRule'
]

{ #category : 'initialization' }
ReDoNotSendSuperStartUpInClassSideRule >> initialize [
	super initialize.
	self
		replace: 'super startUp: `@arg.'
		with: ''
]

{ #category : 'testing' }
ReDoNotSendSuperStartUpInClassSideRule >> shouldCheckMethod: aMethod [

	^ aMethod selector = #startUp: and: [ aMethod methodClass isMeta ]
]
