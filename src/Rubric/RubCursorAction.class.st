Class {
	#name : 'RubCursorAction',
	#superclass : 'Object',
	#instVars : [
		'cmdPressed',
		'optionPressed'
	],
	#category : 'Rubric-Editing-Core',
	#package : 'Rubric',
	#tag : 'Editing-Core'
}

{ #category : 'as yet unclassified' }
RubCursorAction class >> cmdPressed: cmdPressed optPressed: optPressed [

	^ self new cmd: cmdPressed; opt: optPressed
]

{ #category : 'as yet unclassified' }
RubCursorAction >> cmd: pressed [

	cmdPressed := pressed 
]

{ #category : 'initialization' }
RubCursorAction >> initialize [ 

	super initialize.

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
