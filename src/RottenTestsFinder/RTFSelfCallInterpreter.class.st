"
I build a selfcall tree from a class and a selector.

The self call tree is as big as possible. That is to say, if calls are made in conditional blocks, they are taken in account independently from the value of the conditional.

See:
	self example
"
Class {
	#name : 'RTFSelfCallInterpreter',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'selfClass',
		'selfSentMethods',
		'considerClassesThat',
		'callStack',
		'rootSelfCall',
		'selfSentMethod'
	],
	#category : 'RottenTestsFinder-SelfInterpreter',
	#package : 'RottenTestsFinder',
	#tag : 'SelfInterpreter'
}

{ #category : 'example' }
RTFSelfCallInterpreter class >> example [
	^ RTFSelfCallInterpreter new
		considerClassesThat: [ :class | class inheritsFrom: Collection ];
		send: #select: fromClass: OrderedCollection;
		rootSelfCall
]

{ #category : 'private' }
RTFSelfCallInterpreter >> canMethodBeAdded [

	^ (considerClassesThat value: selfSentMethod methodClass) 
		| selfSentMethod isPrimitive
		| (selfSentMethods includes: selfSentMethod)
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> considerClassesThat [
	^ considerClassesThat
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> considerClassesThat: anObject [
	considerClassesThat := anObject
]

{ #category : 'initialization' }
RTFSelfCallInterpreter >> initialize [
	super initialize.
	selfSentMethods := OrderedCollection new.
	callStack := Stack new
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> rootSelfCall [
	^ rootSelfCall
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> rootSelfCall: anObject [
	rootSelfCall := anObject
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> selfSentMethods [
	^ selfSentMethods
]

{ #category : 'api' }
RTFSelfCallInterpreter >> send: aSelector fromClass: aClass [

	| method |
	selfClass := aClass.
	method := selfClass lookupSelector: aSelector.

	callStack push: (RTFSelfCallRootNode compiledMethod: method).
	method ast acceptVisitor: self.
	rootSelfCall := callStack pop
]

{ #category : 'private' }
RTFSelfCallInterpreter >> setMethodFromNode: aMessageNode [

	| lookupClass |
	lookupClass := aMessageNode receiver isSuperVariable
		               ifTrue: [ selfClass superclass ]
		               ifFalse: [ selfClass ].

	selfSentMethod := lookupClass lookupSelector: aMessageNode selector.
	selfSentMethod class = RTFMethodTracer ifTrue: [ selfSentMethod := selfSentMethod method ]
]

{ #category : 'visiting' }
RTFSelfCallInterpreter >> visitMessageNode: aMessageNode [

	^ self visitMessageNode: aMessageNode ifMissingMethod: [
			Warning signal: ('#{1} can not be found in {2} nor in any super class.' format: {
						 aMessageNode selector.
						 selfClass name }).
			^ self ]
]

{ #category : 'visiting' }
RTFSelfCallInterpreter >> visitMessageNode: aMessageNode ifMissingMethod: aBlock [

	| callNode |
	self visitNodes: aMessageNode.
	(aMessageNode receiver isSelfVariable or: [ aMessageNode receiver isSuperVariable ]) ifFalse: [ ^ self ].
	self setMethodFromNode: aMessageNode.
	selfSentMethod ifNil: [
			aBlock value. ^ self ].
	callNode := RTFSelfCallNode astNode: aMessageNode compiledMethod: selfSentMethod.
	callStack top addCall: callNode.
	self canMethodBeAdded ifFalse: [ ^ self ].
	selfSentMethods add: selfSentMethod.
	callStack push: callNode.
	selfSentMethod ast acceptVisitor: self.
	callStack pop
]

{ #category : 'visiting' }
RTFSelfCallInterpreter >> visitNodes: aMessageNode [

	aMessageNode receiver acceptVisitor: self.
	aMessageNode arguments do: [ :each | each acceptVisitor: self ]
]
