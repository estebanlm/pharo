Class {
	#name : 'OCCompilationUndeclaredTest',
	#superclass : 'TestCase',
	#category : 'OpalCompiler-Tests-Misc',
	#package : 'OpalCompiler-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
OCCompilationUndeclaredTest >> testUndeclaredVariable [
	| cm undeclaredBinding |
	cm := OpalCompiler new
		source:
			'methodWithUndeclaredVar
											^ undeclaredTestVar';
		class: OCMockCompilationClass;
		permitFaulty: true;
		compileOrFail.

	undeclaredBinding := cm literals detect: [ :each | each name = #undeclaredTestVar ].
	self assert: undeclaredBinding class equals: UndeclaredVariable.
	self assert: undeclaredBinding identicalTo: (Undeclared associationAt: #undeclaredTestVar).
	self assert: (undeclaredBinding registeredMethods includes: cm).
	"but as the method is not installed, it is not a usingMethod"
	self deny: (undeclaredBinding usingMethods includes: cm).
	undeclaredBinding unregister
]

{ #category : 'tests' }
OCCompilationUndeclaredTest >> testUndeclaredVariableWhenItIsAlreadyRegistered [
	| cm undeclaredBinding var |
	var := UndeclaredVariable registeredWithName: #undeclaredTestVar.
	cm := OpalCompiler new
		source:
			'methodWithUndeclaredVar
											^ undeclaredTestVar';
		class: OCMockCompilationClass;
		permitFaulty: true;
		compileOrFail.

	undeclaredBinding := cm literals detect: [ :each | each name = #undeclaredTestVar ].
	self assert: undeclaredBinding identicalTo: var.
	undeclaredBinding unregister
]

{ #category : 'tests' }
OCCompilationUndeclaredTest >> testUndeclaredVariableWhenItIsAlreadyRegisteredAsAssociation [
	"Test describes current state of bootstrap where undeclared vars are encoded using associations.
	It breaks introduced logic which explicitly return existing variable from Undeclared registry.
	Compiler parts expect kind of variable and not a simple association.
	The bootstrap will be updated at some point. But now this case needs to be supported:
		- declaring undefined var should update registered variable when its type is not undeclared var"
	| newCompiledMethod undeclaredBinding |
	(UndeclaredVariable named: #undeclaredTestVar) register.
	newCompiledMethod := OpalCompiler new
		source:
			'methodWithUndeclaredVar
											^ undeclaredTestVar';
		class: OCMockCompilationClass;
		permitFaulty: true;
		compileOrFail.

	undeclaredBinding := newCompiledMethod literals detect: [ :each | each name = #undeclaredTestVar ].
	self assert: undeclaredBinding class equals: UndeclaredVariable.
	self assert: undeclaredBinding identicalTo: (Undeclared associationAt: #undeclaredTestVar).
	undeclaredBinding unregister
]
