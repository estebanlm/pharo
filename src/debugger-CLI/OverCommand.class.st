Class {
	#name : 'OverCommand',
	#superclass : 'DebuggerCommand',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'printing' }
OverCommand >> executeOn: aDebugger with: args [

	[ aDebugger session stepOver ]
		on: Error
		do: [ :ex |
				(ex value asString includesSubstring: 'computation has been terminated') ifTrue: [ ^ aDebugger finishedDebugging ].
				ex pass ].

	aDebugger context: aDebugger process suspendedContext.

	aDebugger context ifNil: [ ^ aDebugger finishedDebugging ].

	^ 'Stepped OVER to: ' , aDebugger context printString , ' (PC: ' , aDebugger context pc asString , ')'
]

{ #category : 'initialization' }
OverCommand >> initialize [

	super initialize.
	self commandName: #( 'over' 'o' ).
	self commandHelp: 'execute next stepOver'.
	self arguments: ''
]
