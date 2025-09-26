Class {
	#name : 'RubMovePageDownAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubMovePageDownAction >> isForward [
	
	^ true 
]

{ #category : 'as yet unclassified' }
RubMovePageDownAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVirtualColumn.
	^ editor sameColumn: position newLine: [ :lineNo | lineNo + editor pageHeight ] forward: self isForward
]
