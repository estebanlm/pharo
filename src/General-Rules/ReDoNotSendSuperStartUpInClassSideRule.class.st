"
Don't send super initialize in class side because the class initialize methods of your superclass  may maintain state level shared state and it can be dangerous to automatically reinitialize it. 

For example, 

[[[  
ZnServer class>>initialize
	ManagedServers := IdentitySet new.
	AlwaysRestart := true.
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self
]]]
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
