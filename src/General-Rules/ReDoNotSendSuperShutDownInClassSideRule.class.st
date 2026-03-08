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
	#instVars : [
		'ruleSelectors'
	],
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
    self replace: 'super shutDown: `@arg.' with: ''.
    self replace: 'super shutDown' with: ''.
    self replace: 'super startUp: `@arg.' with: ''.
    self replace: 'super startUp' with: ''.

    ruleSelectors := { #shutDown:. #shutDown. #startUp:. #startUp }
]

{ #category : 'testing' }
ReDoNotSendSuperShutDownInClassSideRule >> shouldCheckMethod: aMethod [

    ^ (ruleSelectors includes: aMethod selector)and: [ aMethod methodClass isMeta ]
]
