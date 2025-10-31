Class {
	#name : 'ReConvertTemporaryToInstanceVariableDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'class',
		'variable',
		'selector',
		'subclassesNotDefiningVar',
		'notMultipleTempOccurences',
		'noReadBeforeWritten'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'execution' }
ReConvertTemporaryToInstanceVariableDriver >> breakingChoices [

	| items |
	items := OrderedCollection new.
	subclassesNotDefiningVar check ifFalse: [ items add: (ReBrowseClassReferencesChoice new driver: self) ].
	^ items
]

{ #category : 'instance creation' }
ReConvertTemporaryToInstanceVariableDriver >> class: aClass selector: aSelector variable: aVariable [

	variable := aVariable.
	selector := aSelector.
	class := aClass
]

{ #category : 'resources' }
ReConvertTemporaryToInstanceVariableDriver >> configureRefactoring [

	refactoring := RBTemporaryToInstanceVariableRefactoring class: class selector: selector variable: variable.
	refactoring prepareForExecution
]

{ #category : 'configuration' }
ReConvertTemporaryToInstanceVariableDriver >> defaultSelectDialog [

	^ super defaultSelectDialog
		  extent: 400@1200;
		  title: 'There are potential breaking changes!';
		  label: self labelBasedOnBreakingChanges;
		  items: self breakingChoices;
		  display: [ :each | each description ];
		  displayIcon: [ :each | self iconNamed: each systemIconName ];
		  openModal
]

{ #category : 'execution' }
ReConvertTemporaryToInstanceVariableDriver >> handleBreakingChanges [

	| select |
	select := self selectDialog.
	select ifNotNil: [ select action ]
]

{ #category : 'ui - dialogs' }
ReConvertTemporaryToInstanceVariableDriver >> labelBasedOnBreakingChanges [

	^ String streamContents: [ :stream |
			  subclassesNotDefiningVar violationMessageOn: stream.
			  stream cr.
			  notMultipleTempOccurences violationMessageOn: stream.
			  stream cr.
			  noReadBeforeWritten violationMessageOn: stream.
			  stream cr. 
			  stream nextPutAll: 'Select a strategy' ]
]

{ #category : 'as yet unclassified' }
ReConvertTemporaryToInstanceVariableDriver >> pushUpInstanceVariableAndRemoveTemp [

	
]

{ #category : 'execution' }
ReConvertTemporaryToInstanceVariableDriver >> runRefactoring [

	self configureRefactoring.
	refactoring failedApplicabilityPreconditions ifNotEmpty: [ :conditions |
			self informConditions: conditions.
			^ false ].
	self setBreakingChangesPreconditions.
	subclassesNotDefiningVar check & notMultipleTempOccurences check & noReadBeforeWritten check
		ifTrue: [ self applyChanges ]
		ifFalse: [ self handleBreakingChanges ]
]

{ #category : 'instance creation' }
ReConvertTemporaryToInstanceVariableDriver >> scopes: aScope class: aClass selector: aSelector variable: aVariable [

	scopes := aScope.
	variable := aVariable.
	selector := aSelector.
	class := aClass
]

{ #category : 'initialization' }
ReConvertTemporaryToInstanceVariableDriver >> setBreakingChangesPreconditions [

	subclassesNotDefiningVar := refactoring preconditionNoSubclassDefinesVar.
	notMultipleTempOccurences := refactoring preconditionNoMultipleTempOccurences.
	noReadBeforeWritten := refactoring preconditionNoReadBeforeWritten
]
