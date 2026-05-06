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

	| currentContext response1 response2 |
	currentContext := Context
		                  sender: nil
		                  receiver: self
		                  method: MockToPrintCode >> #mockMethodForTesting:and:
		                  arguments: #( 1  32).
	debugger context: currentContext.

	response1 := debugger executeCommand: 'print arg1'.

	self assert: response1 equals: 'arg1 : 1'.
	
	response2 := debugger executeCommand: 'print arg2'.

	self assert: response2 equals: 'arg2 : 32'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintCode [

	| currentContext response |
	currentContext := Context
		                  sender: nil
		                  receiver: self
		                  method: MockToPrintCode >> #mockMethodForTesting:
		                  arguments: #(  ).
	debugger context: currentContext.

	response := debugger executeCommand: 'printCode'.

	self assert: (response includesSubstring: 'mockMethodForTesting: arg').
	self assert: (response includesSubstring: '"Fake method to test printCode"').
	self assert: (response includesSubstring: 'a := 42.').
	self assert: (response includesSubstring: 'b := a + 1.').
	self assert: (response includesSubstring: '^ b * arg').

	self assert: debugger isActive.
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintError [

	| currentContext response |
	currentContext := Context
		                  sender: nil
		                  receiver: self
		                  method: MockToPrintCode >> #mockMethodForTesting:and:
		                  arguments: #( 1 32 ).
	debugger context: currentContext.

	response := debugger executeCommand: 'print arg'.

	self assert: debugger isActive.
	self assert: response equals: 'Error evaluating: arg'
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
	| currentContext response |
	currentContext := Context
		                  sender: nil
		                  receiver: self
		                  method: MockToPrintCode >> #mockMethodForTesting:and:
		                  arguments: #( 1 32 ).
	debugger context: currentContext.
	
	response := debugger executeCommand: 'print '.

	self assert: response equals: 'Nothing to print'.

	
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
