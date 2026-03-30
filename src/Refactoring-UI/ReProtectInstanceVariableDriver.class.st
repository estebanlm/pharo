"
I handle the interaction for the user when calling `Protect Instance Variable` refactoring
"
Class {
	#name : 'ReProtectInstanceVariableDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'class',
		'variable'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'configuration' }
ReProtectInstanceVariableDriver >> instantiateRefactoring [

	^ ReProtectInstanceVariableRefactoring variable: variable name class: class
]

{ #category : 'execution' }
ReProtectInstanceVariableDriver >> runRefactoring [

	self configureRefactoring.
	refactoring failedApplicabilityPreconditions ifNotEmpty: [ :conditions |
			self informConditions: conditions.
			^ false ].
	self applyChanges
]

{ #category : 'instance creation' }
ReProtectInstanceVariableDriver >> scopes: aScope variable: aVariable class: aClass [

	scopes := aScope.
	model := self refactoringScopeOn: scopes first.
	variable := aVariable.
	class := aClass
]
