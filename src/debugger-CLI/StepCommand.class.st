Class {
	#name : 'StepCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
StepCommand >> executeOn: aDebugger with: arguments [

	[ aDebugger process step ]
		on: Error
		do: [ :ex |
				aDebugger process isTerminated ifTrue: [ ^ aDebugger finishedDebugging ].
				ex pass ].
	aDebugger context: aDebugger process suspendedContext.

	aDebugger context ifNil: [ ^ aDebugger finishedDebugging ].

	^ 'Stepped to: ' , aDebugger context printString , '(PC: ' , aDebugger context pc printString , ')'
]

{ #category : 'initialization' }
StepCommand >> initialize [

	super initialize.
	self commandName: #( 'step' 's' ).
	self commandHelp: 'execute next stepInto'
]
