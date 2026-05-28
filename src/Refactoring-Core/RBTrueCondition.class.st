Class {
	#name : 'RBTrueCondition',
	#superclass : 'RBNewAbstractCondition',
	#category : 'Refactoring-Core',
	#package : 'Refactoring-Core'
}

{ #category : 'checking' }
RBTrueCondition >> check [

	^ true
]

{ #category : 'checking' }
RBTrueCondition >> errorString [ 

	^ ' true '
]

{ #category : 'checking' }
RBTrueCondition >> violators [ 

	^ OrderedCollection new
]
