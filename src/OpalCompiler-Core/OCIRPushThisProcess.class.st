"
I model push thisThisProcess bytecode
"
Class {
	#name : 'OCIRPushThisProcess',
	#superclass : 'OCIRAccess',
	#category : 'OpalCompiler-Core-IR-Nodes',
	#package : 'OpalCompiler-Core',
	#tag : 'IR-Nodes'
}

{ #category : 'visiting' }
OCIRPushThisProcess >> accept: aVisitor [
	^ aVisitor visitPushThisProcess: self
]

{ #category : 'as yet unclassified' }
OCIRPushThisProcess >> deltaStack [

	^ 1
]

{ #category : 'testing' }
OCIRPushThisProcess >> isRemovableByPop [

	^ true
]
