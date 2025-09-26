Class {
	#name : 'RubMoveEndAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubMoveEndAction >> endOfBuffer: editor [

	^ editor string size + 1
]

{ #category : 'as yet unclassified' }
RubMoveEndAction >> endOfLine: position editor: editor [

	| string |

	string := editor string.
	^ string indexOf: Character cr startingAt: position ifAbsent: [ string size + 1 ]
]

{ #category : 'as yet unclassified' }
RubMoveEndAction >> isForward [
	
	^ true
]

{ #category : 'as yet unclassified' }
RubMoveEndAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVirtualColumn.
	^ cmdPressed
		  ifTrue: [ self endOfBuffer: editor ]
		  ifFalse: [ self endOfLine: position editor: editor ]
]
