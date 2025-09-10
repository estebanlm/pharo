Class {
	#name : 'DebugInfoBuilder',
	#superclass : 'Object',
	#instVars : [
		'compiledCode',
		'bytecodeToASTCache'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
DebugInfoBuilder class >> for: code [

	^ self new
		  compiledCode: code;
		  yourself
]

{ #category : 'building' }
DebugInfoBuilder >> build [

	| debugInfo stopTable astScopes scopes |
	debugInfo := DebugInfo new.
	debugInfo sourceCode: self sourceCode.

	stopTable := compiledCode symbolicBytecodes
		             collect: [ :e |
				             | data |
				             data := {
					                     (self computeShouldStopAt: e offset).
					                     (self computeIsSourceStore: e offset).
					                     (self computeIsSourceReturn: e offset).
					                     (self computeIsSourceSend: e offset).
					                     (self computeRangeForPC: e offset) }.
				             e offset -> data ]
		             as: Dictionary.
	debugInfo stopTable: stopTable.

	astScopes := (OCScopesCollector new visitNode: compiledCode ast)
		             scopes.

	scopes := Dictionary new.
	astScopes do: [ :astScope |
			| cachedScope tempDescriptions |
			cachedScope := DebugScope new.
			tempDescriptions := astScope allTemps collect: [ :temp |
				                    temp descriptionArrayForScope: astScope ].
			(astScope isBlockScope and: [ astScope isOptimized ])
				ifTrue: [
						| mappedPCs bytecodeToASTCache blockBody blockStatements |
						blockBody := astScope node body.
						blockStatements := blockBody statements.
						bytecodeToASTCache := astScope outerNotOptimizedScope node
							                      bcToASTCache.
						blockStatements
							ifEmpty: [
							mappedPCs := bytecodeToASTCache pcsForNode: blockBody ]
							ifNotEmpty: [
									mappedPCs := (bytecodeToASTCache pcsForNode:
										              blockStatements first) first to:
									             (bytecodeToASTCache pcsForNode:
										              blockStatements last) last ].
						cachedScope bytecodeRange: (mappedPCs first to: mappedPCs last) ]
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
	debugInfo rootScope: (scopes at: compiledCode ast scope).

	^ debugInfo
]

{ #category : 'accessing' }
DebugInfoBuilder >> compiledCode [

	^ compiledCode
]

{ #category : 'accessing' }
DebugInfoBuilder >> compiledCode: anObject [

	compiledCode := anObject
]

{ #category : 'building' }
DebugInfoBuilder >> computeIsSourceReturn: aBytecodePC [

	"We should stop at all returns inserted by the compiler in the bytecode.
	This includes:
	 - explicit returns with ^ -- these are in the AST
	 - implicit block local returns -- not in AST
	 - implicit method returns -- not in AST"
	^ compiledCode encoderClass isReturnAt: aBytecodePC in: compiledCode
]

{ #category : 'building' }
DebugInfoBuilder >> computeIsSourceSend: aBytecodePC [

	"Deal with inlined messages using isFirstPCOfMessagePC:"
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isMessage and: [
		  self isFirstPCOfMessage: aBytecodePC ]
]

{ #category : 'building' }
DebugInfoBuilder >> computeIsSourceStore: aBytecodePC [
	
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isAssignment 
]

{ #category : 'building' }
DebugInfoBuilder >> computeRangeForPC: aPC [

	^ (self privateSourceNodeForPC: aPC) debugHighlightRange
]

{ #category : 'building' }
DebugInfoBuilder >> computeShouldStopAt: aBytecodePC [

	^ (self computeIsSourceSend: aBytecodePC) or: [
			  (self computeIsSourceReturn: aBytecodePC) or: [
				  self computeIsSourceStore: aBytecodePC ] ]
]

{ #category : 'private' }
DebugInfoBuilder >> isFirstPCOfMessage: aBytecodePC [

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
DebugInfoBuilder >> privateSourceNodeForPC: aBytecodePC [

	| sourceNode |

	"Lazy initialize the bytecode to AST cache"
	bytecodeToASTCache ifNotNil: [
		^ bytecodeToASTCache nodeForPC: aBytecodePC ].

	sourceNode := compiledCode sourceNode.
	bytecodeToASTCache := OCBytecodeToASTCache generateForNode:
		                      sourceNode.
	^ bytecodeToASTCache nodeForPC: aBytecodePC
]

{ #category : 'accessing' }
DebugInfoBuilder >> sourceCode [
	
	^ compiledCode sourceCode
]
