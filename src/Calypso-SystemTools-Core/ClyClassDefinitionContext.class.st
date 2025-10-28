Class {
	#name : 'ClyClassDefinitionContext',
	#superclass : 'ClySourceCodeContext',
	#category : 'Calypso-SystemTools-Core-Editors-Classes',
	#package : 'Calypso-SystemTools-Core',
	#tag : 'Editors-Classes'
}

{ #category : 'testing' }
ClyClassDefinitionContext >> isInstanceSide [

	^ selectedSourceNode parent class = CDClassDefinitionNode
]
