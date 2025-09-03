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

{ #category : 'accessing' }
OldDebugInfo >> debugScopeAt: aBytecodePC [

	| node scope |
	node := self privateSourceNodeForPC: aBytecodePC.
	scope := node isBlock
		         ifTrue: [ node parent methodOrBlockNode scope ]
		         ifFalse: [ node methodOrBlockNode scope ].
	^ OldDebugScope on: scope
]

{ #category : 'accessing' }
OldDebugInfo >> initialPC [

	^ compiledCode initialPC
]

{ #category : 'testing' }
OldDebugInfo >> isSourceReturn: aBytecodePC [

	"We should stop at all returns inserted by the compiler in the bytecode.
	This includes:
	 - explicit returns with ^ -- these are in the AST
	 - implicit block local returns -- not in AST
	 - implicit method returns -- not in AST"
	^ compiledCode encoderClass isReturnAt: aBytecodePC in: compiledCode
]

{ #category : 'testing' }
OldDebugInfo >> isSourceSend: aBytecodePC [

	^ (self privateSourceNodeForPC: aBytecodePC) isMessage and: [
		  self shouldStopAt: aBytecodePC ]
]

{ #category : 'testing' }
OldDebugInfo >> isSourceStore: aBytecodePC [
	
	^ (self privateSourceNodeForPC: aBytecodePC) isAssignment 
]

{ #category : 'testing' }
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

{ #category : 'testing' }
OldDebugInfo >> readVariableNamed: aName at: aContext [

	^ (self debugScopeAt: aContext pc)
		  readVariableNamed: aName
		  at: aContext
]

{ #category : 'accessing' }
OldDebugInfo >> shouldStopAt: aBytecodePC [

	"Is this PC the first PC in its lexical context (the sequence node)?
	A single AST node can spawn multiple bytecode.
	Get the first PC of that node to check if it is the one we are looking for.
	Take into account also that optimized blocks will not have a bc mapping so we need to get its outest parent that has it."
	| mappedNode |
	mappedNode := self privateSourceNodeForPC: aBytecodePC.
	^ (mappedNode methodOrBlockNode scope outerNotOptimizedScope node firstPcForNode: mappedNode) = aBytecodePC
]

{ #category : 'accessing' }
OldDebugInfo >> sourceCode [
	
	^ compiledCode sourceCode
]

{ #category : 'accessing' }
OldDebugInfo >> variableNamesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variableNames
]

{ #category : 'accessing' }
OldDebugInfo >> variablesAt: aBytecodePC [

	^ (self debugScopeAt: aBytecodePC) variables
]
