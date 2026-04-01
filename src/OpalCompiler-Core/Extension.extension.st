Extension { #name : 'Extension' }

{ #category : '*OpalCompiler-Core' }
Extension >> compile: sourceCode classified: protocol withStamp: changeStamp notifying: requestor logSource: logSource [
	"Return the selector of the compiled method"

	^ self compile: sourceCode notifying: requestor methodInstaller: (self methodInstaller
			   logged: logSource;
			   changeStamp: changeStamp;
			   protocol: protocol;
			   shouldRecompileDependencies: true)
]

{ #category : '*OpalCompiler-Core' }
Extension >> compile: sourceCode notifying: requestor methodInstaller: methodInstaller [
	"Return the selector of the compiled method"

	| method compiler ast selectorSymbol scopedSelector |
	
	sourceCode ifEmpty: [ Error signal: 'The source code should not be empty' ].
	compiler := self compiler
		            source: sourceCode;
		            requestor: requestor;
		            failBlock: (requestor ifNotNil: [ [ ^ nil ] ]);
		            "no failblock if no requestor"
						"compatibility: permit undeclared if no requestor"
						permitUndeclared: false;
		            permitFaulty: false.

	ast := compiler parse.
	
	selectorSymbol := ast selector.
	scopedSelector := self internScopedSelector: selectorSymbol.
	ast selector: scopedSelector.
	ast sendNodes do: [ :send | send selector: (OCSelectorNode value: (self package visibleSelectorForSymbol: send selector)) ].

	method := compiler compile.
	methodInstaller install: method into: self compiler: compiler.
	^ ast selector
]
