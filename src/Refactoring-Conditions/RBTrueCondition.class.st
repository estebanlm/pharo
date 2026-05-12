Class {
	#name : 'RBTrueCondition',
	#superclass : 'RBNewAbstractCondition',
	#category : 'Refactoring-Conditions',
	#package : 'Refactoring-Conditions'
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
