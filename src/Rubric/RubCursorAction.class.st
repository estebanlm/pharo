Class {
	#name : 'RubCursorAction',
	#superclass : 'Object',
	#instVars : [
		'ctrlPressed',
		'optionPressed'
	],
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubCursorAction class >> ctrlPressed: ctrlPressed optPressed: optPressed [

	^ self new ctrl: ctrlPressed; opt: optPressed
]

{ #category : 'as yet unclassified' }
RubCursorAction >> ctrl: pressed [

	ctrlPressed := pressed 
]

{ #category : 'initialization' }
RubCursorAction >> initialize [ 

	super initialize.
	optionPressed := false
]

{ #category : 'as yet unclassified' }
RubCursorAction >> isForward [
	
	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RubCursorAction >> moveFromPosition: position inEditor: editor [
	self subclassResponsibility.
]

{ #category : 'initialization' }
RubCursorAction >> opt: pressed [

	optionPressed := pressed
]
