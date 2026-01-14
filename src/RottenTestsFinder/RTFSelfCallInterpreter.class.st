"
I build a selfcall tree from a class and a selector.

The self call tree is as big as possible. That is to say, if calls are made in conditional blocks, they are taken in account independently from the value of the conditional.

See:
	self example
"
Class {
	#name : 'RTFSelfCallInterpreter',
	#superclass : 'RTFSelfCallVisitorTemplate',
	#instVars : [
		'callStack',
		'rootSelfCall'
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
RTFSelfCallInterpreter >> analyze [

	super analyze.
	callStack push: callStack top subCalls last.
	selfSentMethod ast acceptVisitor: self.
	callStack pop
]

{ #category : 'accessing' }
RTFSelfCallInterpreter >> considerClassesThat [
	^ considerClassesThat
]

{ #category : 'initialization' }
RTFSelfCallInterpreter >> initialize [ 

	super initialize.
	callStack := Stack new
]

{ #category : 'private' }
RTFSelfCallInterpreter >> preAnalysisHook: aMessageNode [

	| callNode |
	callNode := RTFSelfCallNode astNode: aMessageNode compiledMethod: selfSentMethod.
	callStack top addCall: callNode.
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

	super setMethodFromNode: aMessageNode.
	selfSentMethod class = RTFMethodTracer ifTrue: [ selfSentMethod := selfSentMethod method ]
]
