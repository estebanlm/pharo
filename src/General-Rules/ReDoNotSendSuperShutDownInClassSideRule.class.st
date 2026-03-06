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
	#name : 'ReDoNotSendSuperShutDownInClassSideRule',
	#superclass : 'ReNodeRewriteRule',
	#category : 'General-Rules-Potential Bugs',
	#package : 'General-Rules',
	#tag : 'Potential Bugs'
}

{ #category : 'accessing' }
ReDoNotSendSuperShutDownInClassSideRule class >> group [
	^ self potentialBugsGroup
]

{ #category : 'accessing' }
ReDoNotSendSuperShutDownInClassSideRule class >> ruleName [

    ^ 'Class-side #shutDown: should not send "super shutDown: arg".'
]

{ #category : 'manifest' }
ReDoNotSendSuperShutDownInClassSideRule class >> uniqueIdentifierName [

    ^ 'ReDoNotSendSuperShutDownInClassSideRule'
]

{ #category : 'initialization' }
ReDoNotSendSuperShutDownInClassSideRule >> initialize [
	super initialize.
	self
		replace: 'super shutDown: `@arg.'
		with: ''
]

{ #category : 'testing' }
ReDoNotSendSuperShutDownInClassSideRule >> shouldCheckMethod: aMethod [

	^ aMethod selector = #shutDown: and: [ aMethod methodClass isMeta ]
]
