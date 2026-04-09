Class {
	#name : 'ReInstanceVariableHasNoReferences',
	#superclass : 'RBNewAbstractCondition',
	#instVars : [
		'violators',
		'aClass',
		'instanceVariable'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'checking' }
ReInstanceVariableHasNoReferences >> check [

	^ self violators isEmpty
]

{ #category : 'accessing' }
ReInstanceVariableHasNoReferences >> errorString [ 

	^ ' Variable ', instanceVariable , ' is still referenced'
]

{ #category : 'instance creation' }
ReInstanceVariableHasNoReferences >> hierarchyOf: aRBClass referencesInstanceVariable: variableName [ 
	aClass := aRBClass.
	instanceVariable := variableName 
]

{ #category : 'initialization' }
ReInstanceVariableHasNoReferences >> initialize [ 
	super initialize.
	violators := OrderedCollection new
]

{ #category : 'accessing' }
ReInstanceVariableHasNoReferences >> violators [

	violators := OrderedCollection new.
	aClass withAllSubclasses do: [ :each |
			| res |
			res := each whichMethodsReferToInstanceVariable: instanceVariable.

			res isNotEmpty ifTrue: [ violators addAll: res ] ].

	^ violators
]
