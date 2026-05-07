Class {
	#name : 'ReRenameArgumentOrTemporaryDriverTest',
	#superclass : 'ReDriverTest',
	#category : 'Refactoring-UI-Tests-Driver',
	#package : 'Refactoring-UI-Tests',
	#tag : 'Driver'
}

{ #category : 'tests' }
ReRenameArgumentOrTemporaryDriverTest >> testGatherUserInputUsesInjectedDialog [

	| method ast node driver dialogMock |
	method := ReClassToConvertTemporaryToInstanceVariable >> #doAction1.
	ast := OpalCompiler new parse: method sourceCode.
	node := ast allChildren detect: [ :n | n isVariable and: [ n name = 'temp' ] ].

	driver := ReRenameArgumentOrTemporaryDriver new.
	driver
		sourceNode: node;
		method: method;
		scopes: { RBBrowserEnvironment default }.

	dialogMock := StRequestDialogMock new.
	dialogMock response: 'tmp2'.
	driver requestDialog: dialogMock.

	driver
		forTesting: true;
		runRefactoring.
	self assert: driver requestDialog isNotNil.
	self assert: driver requestDialog ~= driver defaultRequestDialog
]
