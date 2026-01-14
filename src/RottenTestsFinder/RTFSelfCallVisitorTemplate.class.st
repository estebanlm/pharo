"
I provide a template to ve overridden for visiting messages nodes sent to self
"
Class {
	#name : 'RTFSelfCallVisitorTemplate',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'selfClass',
		'selfSentMethods',
		'considerClassesThat',
		'selfSentMethod'
	],
	#category : 'RottenTestsFinder-SelfInterpreter',
	#package : 'RottenTestsFinder',
	#tag : 'SelfInterpreter'
}

{ #category : 'private' }
RTFSelfCallVisitorTemplate >> analyze [

	selfSentMethods add: selfSentMethod.
]

{ #category : 'accessing' }
RTFSelfCallVisitorTemplate >> considerClassesThat [
	^ considerClassesThat
]

{ #category : 'accessing' }
RTFSelfCallVisitorTemplate >> considerClassesThat: anObject [
	considerClassesThat := anObject
]

{ #category : 'initialization' }
RTFSelfCallVisitorTemplate >> initialize [

	super initialize.
	selfSentMethods := OrderedCollection new.
]

{ #category : 'private' }
RTFSelfCallVisitorTemplate >> isMethodAnalyzable [

	^ (considerClassesThat value: selfSentMethod methodClass) 
		| selfSentMethod isPrimitive
		| (selfSentMethods includes: selfSentMethod)
]

{ #category : 'private' }
RTFSelfCallVisitorTemplate >> preAnalysisHook: aMessageNode [

	^ self
]

{ #category : 'accessing' }
RTFSelfCallVisitorTemplate >> selfClass: aClass [

	selfClass := aClass 
]

{ #category : 'accessing' }
RTFSelfCallVisitorTemplate >> selfSentMethods [
	^ selfSentMethods
]

{ #category : 'private' }
RTFSelfCallVisitorTemplate >> setMethodFromNode: aMessageNode [

	| lookupClass |
	lookupClass := aMessageNode receiver isSuperVariable
		               ifTrue: [ selfClass superclass ]
		               ifFalse: [ selfClass ].

	selfSentMethod := lookupClass lookupSelector: aMessageNode selector
]

{ #category : 'visiting' }
RTFSelfCallVisitorTemplate >> visitMessageNode: aMessageNode [

	^ self visitMessageNode: aMessageNode ifMissingMethod: [
			Warning signal: ('#{1} can not be found in {2} nor in any super class.' format: {
						 aMessageNode selector.
						 selfClass name }).
			^ self ]
]

{ #category : 'visiting' }
RTFSelfCallVisitorTemplate >> visitMessageNode: aMessageNode ifMissingMethod: aBlock [

	self visitNodes: aMessageNode.
	(aMessageNode receiver isSelfVariable 
		or: [ aMessageNode receiver isSuperVariable ]) 
			ifFalse: [ ^ self ].
	self setMethodFromNode: aMessageNode.
	selfSentMethod ifNil: [
			aBlock value.
			^ self ].
	self preAnalysisHook: aMessageNode.
	self isMethodAnalyzable 
		ifTrue: [ self analyze ]
]

{ #category : 'visiting' }
RTFSelfCallVisitorTemplate >> visitNodes: aMessageNode [

	aMessageNode receiver acceptVisitor: self.
	aMessageNode arguments do: [ :each | each acceptVisitor: self ]
]
