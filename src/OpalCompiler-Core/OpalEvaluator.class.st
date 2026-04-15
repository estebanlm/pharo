Class {
	#name : 'OpalEvaluator',
	#superclass : 'Object',
	#instVars : [
		'failBlock',
		'permitFaultyEvaluation',
		'compiler'
	],
	#category : 'OpalCompiler-Core-FrontEnd',
	#package : 'OpalCompiler-Core',
	#tag : 'FrontEnd'
}

{ #category : 'adding' }
OpalEvaluator >> addParsePlugin: anOCDynamicASTCompilerPlugin [

	compiler addParsePlugin: anOCDynamicASTCompilerPlugin
]

{ #category : 'accessing' }
OpalEvaluator >> evaluate: aString [

	| doItMethod |
	compiler source: aString.
	compiler permitFaulty: (permitFaultyEvaluation ifNil: [ false ]).
	compiler permitUndeclared: compiler permitFaulty.
	doItMethod := compiler compile.

	(compiler ast allNotices select: [ :e | e isErrorOn: compiler ]) sorted do: [ :n |
		failBlock ifNotNil: [ ^ failBlock cull: n ].
		n signalError ].


	compiler ast ifNil: [ ^ nil ].
	doItMethod ifNil: [ ^ nil ].

	^ nil withArgs: #(  ) executeMethod: doItMethod
]

{ #category : 'accessing' }
OpalEvaluator >> failBlock: aFullBlockClosure [ 
	
	failBlock := aFullBlockClosure
]

{ #category : 'accessing' }
OpalEvaluator >> initialize [

	super initialize.
	compiler := OpalCompiler new.
	compiler isScripting: true
]

{ #category : 'public access' }
OpalEvaluator >> permitFaulty: aBoolean [ 
	
	permitFaultyEvaluation := aBoolean
]
