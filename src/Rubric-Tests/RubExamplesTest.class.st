Class {
	#name : 'RubExamplesTest',
	#superclass : 'TestCase',
	#category : 'Rubric-Tests-Examples',
	#package : 'Rubric-Tests',
	#tag : 'Examples'
}

{ #category : 'tests' }
RubExamplesTest >> testRubTextFieldExampleSmoke [

	| morph |
	[ self shouldnt: [ morph := RubTextFieldExample exampleOpen ] raise: Error ] ensure: [ morph ifNotNil: [ morph delete ] ]
]

{ #category : 'tests' }
RubExamplesTest >> testRubTextFieldWithEntryCompletionExampleSmoke [

	| morph |
	[ self shouldnt: [ morph := RubTextFieldWithEntryCompletionExample exampleOpen ] raise: Error ] ensure: [ morph ifNotNil: [ morph delete ] ]
]

{ #category : 'tests' }
RubExamplesTest >> testRubWorkspaceExampleSmoke [

	| morph |
	[ self shouldnt: [ morph := RubWorkspaceExample exampleWindowWithScrolledText ] raise: Error ] ensure: [ morph ifNotNil: [ morph delete ] ].
	[ self shouldnt: [ morph := RubWorkspaceExample exampleWithCustomShortcut ] raise: Error ] ensure: [ morph ifNotNil: [ morph delete ] ]
]
