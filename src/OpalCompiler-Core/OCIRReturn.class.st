"
Instruction ""returnTop""
"
Class {
	#name : 'OCIRReturn',
	#superclass : 'OCIRInstruction',
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'visiting' }
OCIRReturn >> accept: aVisitor [
	^ aVisitor visitReturn: self
]

{ #category : 'as yet unclassified' }
OCIRReturn >> deltaStack [

	^ 0
]

{ #category : 'testing' }
OCIRReturn >> isReturn [

	^ true
]

{ #category : 'accessing' }
OCIRReturn >> nonBodySuccessorSequences [
	^#()
]
