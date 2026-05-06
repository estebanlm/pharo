Class {
	#name : 'CommandLineDebuggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugger'
	],
	#category : 'debugger-CLI-Tests',
	#package : 'debugger-CLI-Tests'
}

{ #category : 'running' }
CommandLineDebuggerTest >> setUp [

	| debuggingProcess |
	super setUp.
	debuggingProcess := [ self class compiler evaluate: 'OCParser parseMethod: foo self' ] newProcess.
	debuggingProcess suspend.
	debugger := CommandLineDebugger new
		            context: debuggingProcess suspendedContext;
		            process: debuggingProcess
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testEmptyCommand [

	| response |
	response := debugger executeCommand: '          '.

	self assert: debugger isActive.
	self assert: response equals: ''
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testExit [

	| response |
	self assert: debugger isActive.
	response := debugger executeCommand: 'exit'.
	self deny: debugger isActive.
	self assert: response equals: 'Bye!'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testOver [
	"testing that the Program Counter changed after executing step"

	| response initialPc |
	initialPc := debugger context pc.

	response := debugger executeCommand: 'over'. 

	self deny: debugger context pc equals: initialPc. 

	self assert: debugger isActive. 

	self assert: (response beginsWith: 'Stepped OVER to:')
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrint [

	"| response arguments |
	arguments := '2+2'.
	response := debugger executeCommand: 'print ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: arguments , ' : 4'"
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintCodeContainsSourceCode [

	| currentContext response |
	currentContext := Context
		                  sender: nil
		                  receiver: self
		                  method: MockToPrintCode >> #mockMethodForTesting
		                  arguments: #(  ).
	debugger context: currentContext.

	response := debugger executeCommand: 'printCode'.

	self assert: (response includesSubstring: 'mockMethodForTesting').
	self assert: (response includesSubstring: '"Fake method to test printCode"').
	self assert: (response includesSubstring: 'a := 42.').
	self assert: (response includesSubstring: 'b := a + 1.').
	self assert: (response includesSubstring: '^ b')
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintCodeDoesNotMoveProcess [

	| response initialPc |
	initialPc := debugger context pc.

	response := debugger executeCommand: 'printCode'.

	self assert: debugger context pc equals: initialPc.

	self assert: debugger isActive.

	self assert: (response beginsWith: '====== Code of')
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintError [

	"| response arguments |
	arguments := '2/0'.
	response := debugger executeCommand: '    print    ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: 'Error evaluating: ' , arguments"
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintStack [

	| response initialPc |
	initialPc := debugger context pc.
	response := debugger executeCommand: 'printStack'.


	self assert: debugger context pc equals: initialPc.

	self assert: debugger isActive.

	self assert: (response isString and: response isNotEmpty).

	self assert: (response includesSubstring: debugger context printString)
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintStackAfterStep [

	| response contextAfterStep |
	debugger executeCommand: 'step'.
	contextAfterStep := debugger context.

	response := debugger executeCommand: 'printStack'.

	self assert: (response includesSubstring: contextAfterStep printString)
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintWithoutArguments [

	"| response arguments |
	arguments := ''.
	response := debugger executeCommand: 'print ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: 'Nothing to print'"
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testStep [
	"testing that the Program Counter changed after executing step"

	| response initialPc |
	initialPc := debugger context pc.

	response := debugger executeCommand: 'step'.

	self deny: debugger context pc equals: initialPc.

	self assert: debugger isActive.

	self assert: (response beginsWith: 'Stepped to:')
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testUnknownCommand [

	| response unknownCommand |
	unknownCommand := 'thisIsAnUnknownCommand'.
	response := debugger executeCommand: unknownCommand.

	self assert: debugger isActive.
	self assert: response equals: 'Unknown command: ' , unknownCommand
]
