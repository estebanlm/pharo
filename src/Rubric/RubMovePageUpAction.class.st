Class {
	#name : 'RubMovePageUpAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubMovePageUpAction >> isForward [
	
	^ false 
]

{ #category : 'as yet unclassified' }
RubMovePageUpAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVirtualColumn.
	^ editor sameColumn: position newLine: [ :lineNo | lineNo - editor pageHeight ] forward: self isForward
]
