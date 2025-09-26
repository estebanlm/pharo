Class {
	#name : 'RubMoveHomeAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubMoveHomeAction >> beginningOfLine: position editor: editor [

	^ (editor string lastIndexOf: Character cr startingAt: position - 1 ifAbsent: [ 0 ]) + 1
]

{ #category : 'as yet unclassified' }
RubMoveHomeAction >> isForward [
	
	^ false 
]

{ #category : 'as yet unclassified' }
RubMoveHomeAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVirtualColumn.
	^ cmdPressed
		  ifTrue: [ 1 ]
		  ifFalse: [ self beginningOfLine: position editor: editor ]
]
