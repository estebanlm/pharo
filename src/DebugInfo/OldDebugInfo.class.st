Class {
	#name : 'OldDebugInfo',
	#superclass : 'Object',
	#instVars : [
		'compiledCode'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
OldDebugInfo class >> for: code [

	^ self new
		  compiledCode: code;
		  yourself
]

{ #category : 'converting' }
OldDebugInfo >> asCachedDebugInfo [

	| cachedInfo stopTable astScopes scopes |
	cachedInfo := CachedDebugInfo new.
	cachedInfo sourceCode: self sourceCode.

	stopTable := compiledCode symbolicBytecodes
		             collect: [ :e |
				             | data |
				             data := {
					                     (self shouldStopAt: e offset).
					                     (self isSourceStore: e offset).
					                     (self isSourceReturn: e offset).
					                     (self isSourceSend: e offset).
					                     (self rangeForPC: e offset) }.
				             e offset -> data ]
		             as: Dictionary.
	cachedInfo stopTable: stopTable.

	astScopes := (OCScopesCollector new visitNode: compiledCode ast)
		             scopes.

	scopes := Dictionary new.
	astScopes do: [ :astScope |
			| cachedScope tempDescriptions |
			cachedScope := CachedDebugScope new.
			tempDescriptions := astScope allTemps collect: [ :temp |
				                    temp descriptionArrayForScope: astScope ].

			(astScope isBlockScope and: [
				 astScope isOptimized and: [
					 astScope node body statements isNotEmpty ] ])
				ifTrue: [
						cachedScope bytecodeRange:
							((astScope outerNotOptimizedScope node bcToASTCache
								  firstRecursiveBcOffsetForStatementNode:
								  astScope node body statements first) to:
								 (astScope outerNotOptimizedScope node lastPcForNode:
									  astScope node body statements last)) ]
				ifFalse: [
						| bytecodeCache |
						bytecodeCache := astScope outerNotOptimizedScope node
							                 bcToASTCache.

						cachedScope bytecodeRange:
							(bytecodeCache firstBcOffset to: bytecodeCache lastBcOffset) ].
			cachedScope variables: tempDescriptions.

			scopes at: astScope put: cachedScope ].

	astScopes do: [ :each |
			scopes
				at: each outerScope
				ifPresent: [ :parent | parent addChild: (scopes at: each) ] ].
	cachedInfo rootScope: (scopes at: compiledCode ast scope).

	^ cachedInfo
]

{ #category : 'accessing' }
OldDebugInfo >> compiledCode [

	^ compiledCode
]

{ #category : 'accessing' }
OldDebugInfo >> compiledCode: anObject [

	compiledCode := anObject
]

{ #category : 'private' }
OldDebugInfo >> debugScopeAt: aBytecodePC [

	| node scope |
	node := self privateSourceNodeForPC: aBytecodePC.
	scope := node isBlock
		         ifTrue: [ node parent methodOrBlockNode scope ]
		         ifFalse: [ node methodOrBlockNode scope ].
	^ OldDebugScope on: scope
]

{ #category : 'api' }
OldDebugInfo >> initialPC [

	^ compiledCode initialPC
]

{ #category : 'api' }
OldDebugInfo >> isArgumentNamed: aName at: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) isArgumentNamed: aName
]

{ #category : 'private' }
OldDebugInfo >> isFirstPCOfMessage: aBytecodePC [

	"Check if the given bytecode PC is the first bytecode PC of its mapped node.
	
	An AST node can be expanded/inlined in many bytecodes.
	But, from a source/user point of view, it does not make sense to stop at each bytecode.
	Instead, let's stop at the first bytecode of the expansion.
	
	The implementation is tricky.
	First we get the AST node for the pc (many pcs can be mapped to the same node).
	Now, a node does not know its expansion.
	It is its (first non-optimized) parent that knows.
	So, fetch its (non-optimized) lexical parent, ask it for the first PC for the mapped node.
	Return if this first PC is the one as argument"
	| mappedNode |
	mappedNode := self privateSourceNodeForPC: aBytecodePC.
	^ (mappedNode methodOrBlockNode scope outerNotOptimizedScope node firstPcForNode: mappedNode) = aBytecodePC
]

{ #category : 'private' }
OldDebugInfo >> isSourceReturn: aBytecodePC [

	"We should stop at all returns inserted by the compiler in the bytecode.
	This includes:
	 - explicit returns with ^ -- these are in the AST
	 - implicit block local returns -- not in AST
	 - implicit method returns -- not in AST"
	^ compiledCode encoderClass isReturnAt: aBytecodePC in: compiledCode
]

{ #category : 'private' }
OldDebugInfo >> isSourceSend: aBytecodePC [

	"Deal with inlined messages using isFirstPCOfMessagePC:"
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isMessage and: [
		  self isFirstPCOfMessage: aBytecodePC ]
]

{ #category : 'private' }
OldDebugInfo >> isSourceStore: aBytecodePC [
	
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isAssignment 
]

{ #category : 'private' }
OldDebugInfo >> privateSourceNodeForPC: aBytecodePC [

	| sourceNode bytecodeToASTCache |
	sourceNode := compiledCode sourceNode.
	bytecodeToASTCache := OCBytecodeToASTCache generateForNode: sourceNode.
	^ bytecodeToASTCache nodeForPC: aBytecodePC
]

{ #category : 'accessing' }
OldDebugInfo >> rangeForPC: aPC [

	^ (self privateSourceNodeForPC: aPC) debugHighlightRange
]

{ #category : 'api' }
OldDebugInfo >> readVariableNamed: aName fromContext: aContext [

	^ (self debugScopeAt: aContext pc)
		  readVariableNamed: aName
		  fromContext: aContext
]

{ #category : 'api' }
OldDebugInfo >> shouldStopAt: aBytecodePC [

	^ (self isSourceSend: aBytecodePC) or: [
			  (self isSourceReturn: aBytecodePC) or: [
				  self isSourceStore: aBytecodePC ] ]
]

{ #category : 'accessing' }
OldDebugInfo >> sourceCode [
	
	^ compiledCode sourceCode
]

{ #category : 'api' }
OldDebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]
