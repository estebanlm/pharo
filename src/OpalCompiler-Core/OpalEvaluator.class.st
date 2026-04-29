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

	| compilationResult |
	compiler source: aString.
	compiler permitFaulty: (permitFaultyEvaluation ifNil: [ false ]).
	compiler permitUndeclared: compiler permitFaulty.
	compilationResult := compiler doCompile.

	compilationResult isError ifTrue: [
		(compilationResult ast allNotices select: [ :e | e isErrorOn: compiler ]) sorted do: [ :n |
			failBlock ifNotNil: [ ^ failBlock cull: n ].
			n signalError ].
		^ nil
	].

	^ nil withArgs: #(  ) executeMethod: compilationResult compiledMethod
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
