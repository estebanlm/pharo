Class {
	#name : 'DebugInfoTest',
	#superclass : 'TestCase',
	#category : 'DebugInfo-Tests',
	#package : 'DebugInfo-Tests'
}

{ #category : 'helpers' }
DebugInfoTest >> methodWithArgumentCapturingContext: anArgument [

	"anArgument is unused, but the context should capture it"
	^ thisContext copy
]

{ #category : 'helpers' }
DebugInfoTest >> methodWithArgumentCapturingFullBlockContext: anArgument [

	"anArgument is unused, but the context should capture it"
	^ [  thisContext copy ] value
]

{ #category : 'helpers' }
DebugInfoTest >> methodWithArgumentCapturingOptimizedBlockContext: anArgument [

	"anArgument is unused, but the context should capture it"
	^ true ifTrue: [ thisContext copy ]
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testBlockArgumentVariableIsArgument [

	| debugInfo context |
	context := [ :blockArgument | thisContext copy ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo isArgumentNamed: #blockArgument at: context)
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testBlockTemporaryVariableIsNotArgument [

	| debugInfo context |
	context := [ :blockArgument | | tempInBlock | thisContext copy ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self deny: (debugInfo isArgumentNamed: #tempInBlock at: context)
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testDoNotListVariablesDefinedInFollowingNonSurroundingLexicalScopes [

	| debugInfo context |
	
	"We capture the context outside of the if statement.
	Thus, the variable defined inside the conditional block should not be visible"
	context := thisContext.
	true ifTrue: [ 
		| inOptimizedScope |  ].

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testDoNotListVariablesDefinedInPreviousNonSurroundingLexicalScopes [

	| debugInfo context |
	
	true ifTrue: [ 
		| inOptimizedScope |  ].

	"We capture the context outside of the if statement.
	Thus, the variable defined inside the conditional block should not be visible"
	context := thisContext.
	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListArguments [

	| debugInfo contextWithArguments |
	contextWithArguments := self methodWithArgumentCapturingContext: 17.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self
		assert: (debugInfo variableNamesAt: contextWithArguments pc)
		equals: #( anArgument )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListBlockArguments [

	| debugInfo context |
	context := [ :blockArgument | thisContext copy ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context blockArgument )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListMethodTemps [

	| debugInfo |
	debugInfo := OldDebugInfo for: thisContext method.

	self assert: (debugInfo variableNamesAt: thisContext pc) equals: #(debugInfo)
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListOptimizedBlockArguments [

	| debugInfo context |
	context := self ifNotNil: [ :blockArgument | 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context blockArgument inOptimizedScope )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListOuterVariables [

	| debugInfo context |
	context := [ thisContext copy ] value.

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListShadowedVariablesAreNotDuplicated [

	| debugInfo context |
	context := [ "Shadowing!"
		           | debugInfo |
		           debugInfo := 17.
		           thisContext copy ] value.

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( context debugInfo )
]

{ #category : 'tests - listing variables' }
DebugInfoTest >> testListVariablesWithinOptimizedContext [

	| debugInfo context |
	
	context := true ifTrue: [ 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo variableNamesAt: context pc)
		equals: #( debugInfo context inOptimizedScope )
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testMethodArgumentVariableIsArgument [

	| debugInfo contextWithArguments |
	contextWithArguments := self methodWithArgumentCapturingContext: 17.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self assert:
		(debugInfo isArgumentNamed: #anArgument at: contextWithArguments)
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testMethodTemporaryVariableIsNotArgument [

	| debugInfo contextWithArguments |
	contextWithArguments := thisContext copy.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self deny: (debugInfo
			 isArgumentNamed: #contextWithArguments
			 at: contextWithArguments)
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testNonExistingVariableIsArgumentRaisesError [

	| debugInfo context |
	context := thisContext copy.
	debugInfo := OldDebugInfo for: context method.

	[ debugInfo isArgumentNamed: #notAVariable at: context.
		self fail ]
		on: Error
		do: [ :err | 
			self assert: err messageText equals: 'Variable not found: notAVariable' ]
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testOptimizedBlockArgumentVariableIsArgument [

	| debugInfo context |
	context := self ifNotNil: [ :blockArgument | 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo isArgumentNamed: #blockArgument at: context)
]

{ #category : 'tests - arguments' }
DebugInfoTest >> testOptimizedBlockTemporaryVariableIsNotArgument [

	| debugInfo context |
	context := self ifNotNil: [ :blockArgument | 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self deny: (debugInfo isArgumentNamed: #inOptimizedScope at: context)
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalBlockArgumentVariable [

	| debugInfo context |
	context := [ :blockArgument | thisContext copy ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #blockArgument at: context) equals: 7
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalBlockTempVectorTemporaryVariableFromClosure [

	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"
	| debugInfo |
	[ :blockArgument |
		| tempInTempVector context |
		tempInTempVector := 42.
		
		"Create and execute a block that steals an enclosing variable"
		"tempInTempVector is assigned in two different lexical contexts.
		It is then candidate to be put in a temp vector, which will be copied in the block activation"	
		[
			tempInTempVector := 3
		] value.
		
		context := thisContext.
		debugInfo := OldDebugInfo for: context method.

		self
			assert: (debugInfo readVariableNamed: #tempInTempVector at: context)
			equals: 3
	] value: 7.
	
	"Verify that the inner block got effectively executed"
	self assert: debugInfo notNil
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalBlockTempVectorTemporaryVariableFromMethod [
	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"

	| debugInfo tempInTempVector context |
	tempInTempVector := 42.

	"Create and execute a block that steals an enclosing variable"
	"tempInTempVector is assigned in two different lexical contexts.
		It is then candidate to be put in a temp vector, which will be copied in the block activation"
	[ tempInTempVector := 3 ] value.

	context := thisContext.
	debugInfo := OldDebugInfo for: context method.

	self
		assert: (debugInfo readVariableNamed: #tempInTempVector at: context)
		equals: 3
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalBlockTemporaryVariable [

	| debugInfo context |
	context := [ :blockArgument | | tempInBlock | tempInBlock := 42. thisContext copy ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #tempInBlock at: context) equals: 42
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalMethodArgumentVariable [

	| debugInfo contextWithArguments |
	contextWithArguments := self methodWithArgumentCapturingContext: 17.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self assert:
		(debugInfo readVariableNamed: #anArgument at: contextWithArguments) equals: 17
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalMethodTemporaryVariable [

	| debugInfo contextWithArguments |
	contextWithArguments := thisContext copy.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self
		deny: (debugInfo
				 readVariableNamed: #contextWithArguments
				 at: contextWithArguments)
		equals: contextWithArguments
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalOptimizedBlockArgumentVariable [

	| debugInfo context |
	context := self ifNotNil: [ :blockArgument | 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #blockArgument at: context) equals: self
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadLocalOptimizedBlockTemporaryVariable [

	| debugInfo context |
	context := self ifNotNil: [ :blockArgument | 
		| inOptimizedScope | 
		"Put an assignment just after the context capture.
		Like this, the captured context PC will be inside the block (at the assignment point).
		Thus, lexically we are inside the block and the variables of the block are visible"
		inOptimizedScope := thisContext copy ].

	debugInfo := OldDebugInfo for: context method.

	self deny: (debugInfo readVariableNamed: #inOptimizedScope at: context) equals: context
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadNonExistingVariableRaisesError [

	| debugInfo context |
	context := thisContext copy.
	debugInfo := OldDebugInfo for: context method.

	[ debugInfo readVariableNamed: #notAVariable at: context.
		self fail ]
		on: Error
		do: [ :err | 
			self assert: err messageText equals: 'Variable not found: notAVariable' ]
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockArgumentVariableFromClosure [

	| debugInfo context |
	context := [ :blockArgument | [thisContext copy] value ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #blockArgument at: context) equals: 7
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockArgumentVariableFromOptimizedBlock [

	| debugInfo context |
	context := [ :blockArgument | true ifTrue: [thisContext copy] ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #blockArgument at: context) equals: 7
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockCopiedArgumentVariableFromClosure [

	| debugInfo context |
	context := [ :blockArgument | [ blockArgument. thisContext copy] value ] value: 7.

	debugInfo := OldDebugInfo for: context method.

	self assert: (debugInfo readVariableNamed: #blockArgument at: context) equals: 7
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockCopiedTemporaryVariableFromClosure [

	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"
	| debugInfo |
	[ :blockArgument |
		| tempInBlock |
		tempInBlock := 42.
		[
			| context |
			"tempInBlock is candidate to be copied in the block activation"
			tempInBlock.

			context := thisContext.
			debugInfo := OldDebugInfo for: context method.

			self
				assert: (debugInfo readVariableNamed: #tempInBlock at: context)
				equals: 42 ] value ] value: 7.
	
	"Verify that the inner block got effectively executed"
	self assert: debugInfo notNil
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockTempVectorTemporaryVariableFromClosure [

	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"
	| debugInfo |
	[ :blockArgument |
		| tempInTempVector |
		tempInTempVector := 42.
		[
			| context |
			"tempInTempVector is assigned in two different lexical contexts.
			It is then candidate to be put in a temp vector, which will be copied in the block activation"
			tempInTempVector := 3.

			context := thisContext.
			debugInfo := OldDebugInfo for: context method.

			self
				assert: (debugInfo readVariableNamed: #tempInTempVector at: context)
				equals: 3 ] value ] value: 7.
	
	"Verify that the inner block got effectively executed"
	self assert: debugInfo notNil
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockTemporaryVariableFromClosure [

	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"
	| debugInfo |
	[ :blockArgument |
		| tempInBlock |
		tempInBlock := 42.
		[
			| context |
			context := thisContext.
			debugInfo := OldDebugInfo for: context method.

			self
				assert: (debugInfo readVariableNamed: #tempInBlock at: context)
				equals: 42 ] value ] value: 7.
	
	"Verify that the inner block got effectively executed"
	self assert: debugInfo notNil
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterBlockTemporaryVariableFromOptimizedBlock [

	"This test is tricky.
	
	If done like the other tests (copying and returning the captured context) this breaks the closures.
	The block contexts refer to closures, and each closure refer to its (creator) outer context.
	However, when copying the stack, they point to the original context and not the copy.
	
	Instead of making a transitive closure of the graph copy, let's just put the assertion in the block
	"
	| debugInfo |
	[ :blockArgument |
		| tempInBlock |
		tempInBlock := 42.
		true ifTrue: [
			| context |
			context := thisContext.
			debugInfo := OldDebugInfo for: context method.

			self
				assert: (debugInfo readVariableNamed: #tempInBlock at: context)
				equals: 42 ] ] value: 7.
	
	"Verify that the inner block got effectively executed"
	self assert: debugInfo notNil
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterMethodArgumentVariableFromClosure [

	| debugInfo contextWithArguments |
	contextWithArguments := self methodWithArgumentCapturingFullBlockContext: 17.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self assert:
		(debugInfo readVariableNamed: #anArgument at: contextWithArguments) equals: 17
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterMethodArgumentVariableFromOptimizedBlock [

	| debugInfo contextWithArguments |
	contextWithArguments := self methodWithArgumentCapturingOptimizedBlockContext: 17.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self assert:
		(debugInfo readVariableNamed: #anArgument at: contextWithArguments) equals: 17
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterMethodTemporaryVariableFromClosure [

	| debugInfo contextWithArguments |
	contextWithArguments := [thisContext copy] value.
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self
		assert: (debugInfo
				 readVariableNamed: #contextWithArguments
				 at: contextWithArguments)
		equals: contextWithArguments
]

{ #category : 'tests - read variables' }
DebugInfoTest >> testReadOuterMethodTemporaryVariableFromOptimizedBlock [

	| debugInfo contextWithArguments outerVariable |
	outerVariable := 17.
	
	contextWithArguments := true ifTrue: [thisContext copy].
	debugInfo := OldDebugInfo for: contextWithArguments method.

	self
		assert: (debugInfo
				 readVariableNamed: #outerVariable
				 at: contextWithArguments)
		equals: outerVariable
]
