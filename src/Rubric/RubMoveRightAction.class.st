Class {
	#name : 'RubMoveRightAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'testing' }
RubMoveRightAction >> isForward [
	
	^ true.
]

{ #category : 'as yet unclassified' }
RubMoveRightAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVisualColumn.
	^ cmdPressed 
		  ifTrue: [ self nextWordPosition: position editor: editor ]
		  ifFalse: [ self nextCharacterPosition: position editor: editor ]
]

{ #category : 'as yet unclassified' }
RubMoveRightAction >> nextCharacterPosition: position editor: editor [

	^ position + 1 min: editor bufferSize + 1
]

{ #category : 'as yet unclassified' }
RubMoveRightAction >> nextWordPosition: position editor: editor [

	^ editor nextWord: position stopOnUpperCase: optionPressed 
]
