Class {
	#name : 'OnlineSourceDebugInfo',
	#superclass : 'Object',
	#instVars : [
		'compiledCode',
		'bytecodeToASTCache'
	],
	#category : 'DebugInfo',
	#package : 'DebugInfo'
}

{ #category : 'instance creation' }
OnlineSourceDebugInfo class >> for: code [

	^ self new
		  compiledCode: code;
		  yourself
]

{ #category : 'private' }
OnlineSourceDebugInfo >> asBitMask: aCollectionOfFlags [

	| flags |
	self assert: aCollectionOfFlags size < SmallInteger maxVal highBit.
	flags := 0.
	aCollectionOfFlags
		do: [ :f | flags := flags + f asBit ]
		separatedBy: [ flags := flags << 1 ].
	^ flags
]

{ #category : 'converting' }
OnlineSourceDebugInfo >> asOfflineDebugInfo [

	| debugInfo stopTable astScopes scopes |
	debugInfo := OfflineSourceDebugInfo new.
	debugInfo sourceCode: nil. "self sourceCode"

	stopTable := compiledCode symbolicBytecodes asArray
		             select: [ :e | self shouldStopAt: e offset ]
		             thenCollect: [ :e |
				             | range stopTableInfo |
				             range := self rangeForPC: e offset.
				             stopTableInfo := {
					                              e offset.
					                              (self asBitMask: {
							                               (self isSourceStore:
								                                e offset).
							                               (self isSourceReturn:
								                                e offset).
							                               (self isSourceSend:
								                                e offset) }).
					                              range first.
					                              range last }.
				             stopTableInfo ].

	"Compress the stop table as a byte array if possible"
	stopTable := stopTable flattened.
	(stopTable allSatisfy: [ :byte | byte < 255 ]) ifTrue: [
		stopTable := stopTable asByteArray ].
	debugInfo stopTable: stopTable.

	astScopes := (OCScopesCollector new visitNode: compiledCode ast)
		             scopes.

	scopes := Dictionary new.
	astScopes do: [ :astScope |
			| cachedScope tempDescriptions |
			cachedScope := OfflineSourceDebugScope new.
			tempDescriptions := astScope allTemps collect: [ :temp |
				                    temp descriptionArrayForScope: astScope ].
			(astScope isBlockScope and: [ astScope isOptimized ])
				ifTrue: [
						| mappedPCs currentScopeBytecodeToASTCache blockBody blockStatements |
						blockBody := astScope node body.
						blockStatements := blockBody statements.
						currentScopeBytecodeToASTCache := astScope outerNotOptimizedScope node
							                      bcToASTCache.
						blockStatements
							ifEmpty: [
								mappedPCs := currentScopeBytecodeToASTCache pcsForNode: blockBody ]
							ifNotEmpty: [
								mappedPCs := ((blockStatements flatCollect: [ :e | { e }, e allChildren ])
									flatCollect: [ :e | currentScopeBytecodeToASTCache pcsForNode: e ] as: Set)
										sorted.
								mappedPCs := mappedPCs first to: mappedPCs last ].
						cachedScope bytecodeRange: (mappedPCs first to: mappedPCs last) ]
				ifFalse: [
						| bytecodeCache |
						bytecodeCache := astScope outerNotOptimizedScope node
							                 bcToASTCache.

						cachedScope bytecodeRange:
							(bytecodeCache firstBcOffset to: bytecodeCache lastBcOffset) ].

			tempDescriptions ifNotEmpty: [
				cachedScope variables: tempDescriptions ].

			scopes at: astScope put: cachedScope ].

	astScopes do: [ :each |
			scopes
				at: each outerScope
				ifPresent: [ :parent | parent addChild: (scopes at: each) ] ].
	debugInfo rootScope: (scopes at: compiledCode ast scope).

	^ debugInfo
]

{ #category : 'accessing' }
OnlineSourceDebugInfo >> compiledCode [

	^ compiledCode
]

{ #category : 'accessing' }
OnlineSourceDebugInfo >> compiledCode: anObject [

	compiledCode := anObject
]

{ #category : 'accessing' }
OnlineSourceDebugInfo >> debugScopeAt: aBytecodePC [

	| node scope |
	node := self privateSourceNodeForPC: aBytecodePC.

	scope := node isBlock
		         ifTrue: [ node parent methodOrBlockNode scope ]
		         ifFalse: [ node methodOrBlockNode scope ].

	^ OnlineSourceDebugScope on: scope
]

{ #category : 'testing' }
OnlineSourceDebugInfo >> isArgumentNamed: aName at: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) isArgumentNamed: aName
]

{ #category : 'private' }
OnlineSourceDebugInfo >> isFirstPCOfMessage: aBytecodePC [

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

{ #category : 'api' }
OnlineSourceDebugInfo >> isSourceReturn: aBytecodePC [

	"We should stop at all returns inserted by the compiler in the bytecode.
	This includes:
	 - explicit returns with ^ -- these are in the AST
	 - implicit block local returns -- not in AST
	 - implicit method returns -- not in AST"
	^ compiledCode encoderClass isReturnAt: aBytecodePC in: compiledCode
]

{ #category : 'api' }
OnlineSourceDebugInfo >> isSourceSend: aBytecodePC [

	"Deal with inlined messages using isFirstPCOfMessagePC:"
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isMessage and: [
		  self isFirstPCOfMessage: aBytecodePC ]
]

{ #category : 'api' }
OnlineSourceDebugInfo >> isSourceStore: aBytecodePC [
	
	(self privateSourceNodeForPC: aBytecodePC) ifNil: [ ^ false ].
	^ (self privateSourceNodeForPC: aBytecodePC) isAssignment 
]

{ #category : 'private' }
OnlineSourceDebugInfo >> privateSourceNodeForPC: aBytecodePC [

	| sourceNode |

	"Lazy initialize the bytecode to AST cache"
	bytecodeToASTCache ifNotNil: [
		^ bytecodeToASTCache nodeForPC: aBytecodePC ].

	sourceNode := compiledCode sourceNode.
	bytecodeToASTCache := OCBytecodeToASTCache generateForNode:
		                      sourceNode.
	^ bytecodeToASTCache nodeForPC: aBytecodePC
]

{ #category : 'api' }
OnlineSourceDebugInfo >> rangeForPC: aPC [

	^ (self privateSourceNodeForPC: aPC) debugHighlightRange
]

{ #category : 'api' }
OnlineSourceDebugInfo >> readVariableNamed: aName fromContext: aContext [

	^ (self debugScopeAt: aContext pc) readVariableNamed: aName fromContext: aContext
]

{ #category : 'api' }
OnlineSourceDebugInfo >> shouldStopAt: aBytecodePC [

	^ (self isSourceSend: aBytecodePC) or: [
			  (self isSourceReturn: aBytecodePC) or: [
				  self isSourceStore: aBytecodePC ] ]
]

{ #category : 'accessing' }
OnlineSourceDebugInfo >> sourceCode [
	
	^ compiledCode sourceCode
]

{ #category : 'accessing' }
OnlineSourceDebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]
