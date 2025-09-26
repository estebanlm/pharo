Class {
	#name : 'RubMoveLeftAction',
	#superclass : 'RubCursorAction',
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'testing' }
RubMoveLeftAction >> isForward [
	
	^ false.
]

{ #category : 'as yet unclassified' }
RubMoveLeftAction >> moveFromPosition: position inEditor: editor [

	editor invalidateVirtualColumn.
	^ cmdPressed 
		  ifTrue: [ self previousWordPosition: position editor: editor ]
		  ifFalse: [ self previousCharacterPosition: position editor: editor ]
]

{ #category : 'as yet unclassified' }
RubMoveLeftAction >> previousCharacterPosition: position editor: editor [
	
	^ position - 1 max: 1
]

{ #category : 'as yet unclassified' }
RubMoveLeftAction >> previousWordPosition: position editor: editor [
	
	^ editor previousWord: position stopOnUpperCase: optionPressed
]
