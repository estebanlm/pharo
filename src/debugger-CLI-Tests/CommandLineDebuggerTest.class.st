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

	super setUp.
	debugger := CommandLineDebugger new
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testEmptyCommand [

	| response |
	response := debugger executeCommand: '          '.

	self assert: debugger isActive.
	self assert: response equals: ''
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testExitCommand [

	| response |

	self assert: debugger isActive. 
	response := debugger executeCommand: 'exit'. 
	self deny: debugger isActive. 
	self assert: response equals: 'Bye!'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testOverCommand [

	| response debugSession |
	debugSession := MockDebugSession new.

	debugger context: debugSession.
	self deny: debugger context hasSteppedOver.

	response := debugger executeCommand: 'over'.
	self assert: debugger context hasSteppedOver.

	self assert: debugger isActive.
	self assert: response equals: 'Stepped over'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testOverWithoutContext [

	| response |
	self deny: debugger hasContext.

	response := debugger executeCommand: 'over'.

	self assert: debugger isActive.
	self assert: response equals: 'No active debug session to step over.'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintCommand [

	| response arguments |
	arguments := '2+2'.
	response := debugger executeCommand: 'print ' , arguments.
	
	self assert: debugger isActive.
	self assert: response equals: arguments , ' : 4'
	
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintError [

	| response arguments |
	arguments := '2/0'.
	response := debugger executeCommand: 'print ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: 'Error evaluating: 2/0'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintErrorWithContext [

	| response arguments context |
	context := MockDebugSession new.
	debugger context: context.
	arguments := '2/0'.
	response := debugger executeCommand: '    print    ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: 'Error evaluating: ', arguments 
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintWithContext [

	| response arguments context|
	context := MockDebugSession new.
	debugger context: context.
	arguments := '2+2'.
	response := debugger executeCommand: 'print ' , arguments.

	self assert: debugger isActive.
	self assert: response equals: arguments , ' : 4'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testPrintWithoutArguments [

	| response arguments |
	arguments := ''.
	response := debugger executeCommand: 'print ' , arguments.
	
	self assert: debugger isActive.
	self assert: response equals: 'Nothing to print'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testStepCommand [

	| response debugSession |
	debugSession := MockDebugSession new.

	debugger context: debugSession.
	self deny: debugger context hasSteppedInto.

	response := debugger executeCommand: 'step'.
	self assert: debugger context hasSteppedInto.

	self assert: debugger isActive.
	self assert: response equals: 'Stepped'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testStepWithoutContext [

	| response |
	self deny: debugger hasContext.

	response := debugger executeCommand: 'step'.

	self assert: debugger isActive.
	self assert: response equals: 'No active debug session to step into.'
]

{ #category : 'tests' }
CommandLineDebuggerTest >> testUnknownCommand [

	| response unknownCommand |
	unknownCommand := 'thisIsAnUnknownCommand'.
	response := debugger executeCommand: unknownCommand.

	self assert: debugger isActive.
	self assert: response equals: 'Unknown command: ' , unknownCommand
]
