Class {
	#name : 'OCInteractiveAPI',
	#superclass : 'Object',
	#instVars : [
		'compiler'
	],
	#category : 'OpalCompiler-UI',
	#package : 'OpalCompiler-UI'
}

{ #category : 'compiling' }
OCInteractiveAPI >> compile: sourceCode notifying: requestor in: behavior [
	"Return the selector of the compiled method"

	| method |
	sourceCode ifEmpty: [ Error signal: 'The source code should not be empty' ].
	compiler := behavior compiler
		            source: sourceCode;
		            requestor: requestor;
		            "compatibility: permit undeclared if no requestor"permitUndeclared: false;
		            permitFaulty: false.

	method := compiler compile.

	compiler compilationResult ifNotNil: [
			compiler ast allNotices sorted do: [ :n |
					| check isInteractive |
					requestor ifNil: [ n signalError ] ifNotNil: [
							isInteractive := requestor notNil and: [ (requestor respondsTo: #interactive) not or: [ requestor interactive ] ].
							check := compiler checkNotice: n requestor: requestor isInteractive: isInteractive.
							check ifNil: [ ^ self compile: requestor text asString notifying: requestor in: behavior ].
							check ifFalse: [ ^ nil ] ] ] ].

	^ method
]

{ #category : 'accessing' }
OCInteractiveAPI >> compiler [

	^ compiler
]

{ #category : 'accessing' }
OCInteractiveAPI >> compiler: anObject [

	compiler := anObject
]
