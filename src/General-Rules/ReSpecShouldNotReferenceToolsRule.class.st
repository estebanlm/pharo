"
This rule warn the user if ```Smalltalk Tools``` is referenced in a Spec subclass, which should not indeed.
"
Class {
	#name : 'ReSpecShouldNotReferenceToolsRule',
	#superclass : 'ReNodeBasedRule',
	#category : 'General-Rules-Optimization',
	#package : 'General-Rules',
	#tag : 'Optimization'
}

{ #category : 'accessing' }
ReSpecShouldNotReferenceToolsRule class >> ruleName [

	^ 'Spec subclasses should not reference Smalltalk tools'
]

{ #category : 'accessing' }
ReSpecShouldNotReferenceToolsRule class >> severity [

	^ #warning
]

{ #category : 'running' }
ReSpecShouldNotReferenceToolsRule >> basicCheck: aNode [

	| class |
	aNode isMessage ifFalse: [ ^ false ].
	class := aNode methodNode compiledMethod methodClass. 
	(class inheritsFrom: StPresenter) ifFalse: [ ^ false ].
	^ self isToolReference: aNode
]

{ #category : 'testing' }
ReSpecShouldNotReferenceToolsRule >> isToolReference: aMessageNode [

	aMessageNode receiver isVariable ifTrue: [
			Smalltalk tools tools valuesDo: [ :toolClass |
				toolClass name = aMessageNode receiver name ifTrue: [ ^ true ] ] ].

	(aMessageNode receiver isMessage and: [
			 aMessageNode receiver selector = #tools and: [ 
					 aMessageNode receiver receiver isVariable and: [
						 aMessageNode receiver receiver name = #Smalltalk ] ] ])
		ifTrue: [ ^ true ].

	^ false
]
