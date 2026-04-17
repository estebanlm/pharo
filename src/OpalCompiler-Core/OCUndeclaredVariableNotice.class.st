Class {
	#name : 'OCUndeclaredVariableNotice',
	#superclass : 'OCErrorNotice',
	#category : 'OpalCompiler-Core-FrontEnd',
	#package : 'OpalCompiler-Core',
	#tag : 'FrontEnd'
}

{ #category : 'testing' }
OCUndeclaredVariableNotice >> isErrorOn: anOpalCompiler [ 
	
	| permitFaulty |	
	"I'm an error if the compiler does not allow faults.
	Otherwise, I'm a warning"
	
	"I'm an error if the setting is not set"
	permitFaulty := anOpalCompiler permitUndeclared or: [ anOpalCompiler permitFaulty ].
	^ permitFaulty ifNil: [ true ]
		ifNotNil: [ permitFaulty not ]
]

{ #category : 'testing' }
OCUndeclaredVariableNotice >> isUndeclaredNotice [

	^ true
]
