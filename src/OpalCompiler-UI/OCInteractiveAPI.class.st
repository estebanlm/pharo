Class {
	#name : 'OCInteractiveAPI',
	#superclass : 'Object',
	#instVars : [
		'compiler',
		'permitFaulty',
		'permitUndeclared',
		'shouldSignalErrors'
	],
	#category : 'OpalCompiler-UI',
	#package : 'OpalCompiler-UI'
}

{ #category : 'compiling' }
OCInteractiveAPI >> checkNotice: aNotice requestor: aRequestor [
	"This method handles all the logic of error handling.
	
	Error handing in the compiler is only performed at one place, after the parsing/semantic analysis/other parse plugins.
	Each ASTNotice in the AST is then checked with this method.

	There is only three outcomes:
	* If this method returns true (OK), then the work of the compiler can continue.
	  Next notice is then processed.
	  Or, if this that was the last notice, compilation and cie can be performed.
	* If this method returns false (not OK), then the compilation is cancelled.
	  The failBlock will be invoked.
	* If this method returns nil (stop checking), then skip the rest of the notice checks.
	  This one is used in case of reparation, where a new (checked) AST is produced.

	Errors that may happen later in the backend are consireded internal errors and should not occur (bugs).

	This method is a little long because it handles the requestor (quirks) mode.
	"

	aNotice isWarning ifTrue: [ ^ true ].
	(aNotice isUndeclaredNotice and: [ compiler permitUndeclared ]) ifTrue: [
			OCUndeclaredVariableWarning new
				notice: aNotice;
				signal.
			^ true ].
			
	"Quirks mode: otherwise, push the error message to the requestor"
	aRequestor notify: aNotice messageText , ' ->' at: aNotice position in: aNotice node source.
	"Quirks mode: Then leave"
	^ false
]

{ #category : 'compiling' }
OCInteractiveAPI >> compile: sourceCode notifying: requestor in: behavior [
	"Return the selector of the compiled method"

	| compilationResult theCompiler |
	theCompiler := self compilerFor: behavior.
	theCompiler ast ifNil: [
			sourceCode ifEmpty: [ Error signal: 'The source code should not be empty' ].
			theCompiler source: sourceCode ].

	compilationResult := theCompiler doCompile.

	compilationResult isError ifTrue: [
			theCompiler ast allNotices sorted do: [ :n |
					| check |
					theCompiler failBlock ifNotNil: [  theCompiler failBlock value: n ].
					shouldSignalErrors ifTrue: [ n signalError ].

					requestor ifNil: [ n signalError ] ifNotNil: [
							check := self checkNotice: n requestor: requestor.
							check ifNil: [ ^ self compile: requestor text asString notifying: requestor in: behavior ].
							check ifFalse: [ ^ nil ] ] ].
			^ nil ].

	^ compilationResult compiledMethod
]

{ #category : 'accessing' }
OCInteractiveAPI >> compiler [
	^ compiler
]

{ #category : 'accessing' }
OCInteractiveAPI >> compiler: aCompiler [

	compiler := aCompiler
]

{ #category : 'compiling' }
OCInteractiveAPI >> compilerFor: behavior [

	^ compiler ifNil: [
			  compiler := behavior compiler
				              permitUndeclared: self permitUndeclared;
				              permitFaulty: self permitFaulty ]
]

{ #category : 'initialization' }
OCInteractiveAPI >> initialize [

	super initialize.
	permitFaulty := false.
	shouldSignalErrors := false.
]

{ #category : 'accessing' }
OCInteractiveAPI >> permitFaulty [

	^ permitFaulty
]

{ #category : 'accessing' }
OCInteractiveAPI >> permitFaulty: anObject [

	permitFaulty := anObject
]

{ #category : 'accessing' }
OCInteractiveAPI >> permitUndeclared [

	^ permitUndeclared ifNil: [ permitFaulty ]
]

{ #category : 'accessing' }
OCInteractiveAPI >> permitUndeclared: anObject [

	permitUndeclared := anObject
]

{ #category : 'accessing' }
OCInteractiveAPI >> shouldSignalErrors [

	^ shouldSignalErrors
]

{ #category : 'accessing' }
OCInteractiveAPI >> shouldSignalErrors: anObject [

	shouldSignalErrors := anObject
]
