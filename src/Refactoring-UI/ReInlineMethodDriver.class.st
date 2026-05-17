"
I represent a driver that invokes Inline Method refactoring, processing user interaction during the execution.
"
Class {
	#name : 'ReInlineMethodDriver',
	#superclass : 'ReInteractionDriver',
	#instVars : [
		'class',
		'selector',
		'interval',
		'noOverridden',
		'notExecutionOrder',
		'noSuperMessage',
		'noLastSender'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'accessing' }
ReInlineMethodDriver class >> driverName [

	^ 'Inline method'
]

{ #category : 'execution' }
ReInlineMethodDriver >> breakingChoices [

	| items |
	items := OrderedCollection new.

	(noOverridden check and: [ notExecutionOrder check and: [ noSuperMessage check ] ]) ifFalse: [
		items add: (ReInlineMethodChoice new driver: self) ]. 
	noLastSender check ifFalse: [ items add: (ReInlineAndRemoveMethodChoice new driver: self) ].
	^ items
]

{ #category : 'configuration' }
ReInlineMethodDriver >> defaultSelectDialog [

	^ super defaultSelectDialog
		  extent: 400 @ 1200;
		  title: 'There are potential breaking changes!';
		  message: self labelBasedOnBreakingChanges;
		  items: self breakingChoices;
		  display: [ :each | each description ];
		  displayIcon: [ :each | self iconNamed: each systemIconName ];
		  yourself
]

{ #category : 'initialization' }
ReInlineMethodDriver >> hasFailedBehaviorPreservingPreconditions [

	noOverridden := refactoring preconditionIsMethodOverridden.
	notExecutionOrder := refactoring preconditionExecutionOrder.
	noSuperMessage := refactoring preconditionSuperMessages.
	noLastSender := refactoring  preconditionIsLastSender. 

	^ refactoring failedBreakingChangePreconditions isNotEmpty
]

{ #category : 'action' }
ReInlineMethodDriver >> inlineAndRemoveMethod [

	| removeRefactoring |
	refactoring privateTransform.
	removeRefactoring := ReRemoveMethodsRefactoring model: model classSelectorMapping: { (class -> selector) }.
	removeRefactoring privateTransform.
	removeRefactoring changes changes do: [ :change | refactoring changes addChange: change ].
	self openPreviewWithChanges: refactoring changes
]

{ #category : 'action' }
ReInlineMethodDriver >> inlineMethod [

	refactoring privateTransform.
	self openPreviewWithChanges: refactoring changes
]

{ #category : 'configuration' }
ReInlineMethodDriver >> instantiateRefactoring [

	^ RBInlineMethodRefactoring inline: interval inMethod: selector forClass: class
]

{ #category : 'ui - dialogs' }
ReInlineMethodDriver >> labelBasedOnBreakingChanges [

	^ String streamContents: [ :stream |
			  refactoring failedBreakingChangePreconditions do: [ :cond |
					  cond violationMessageOn: stream.
					  stream cr ].
			  stream cr.
			  stream nextPutAll: 'Select a strategy' ]
]

{ #category : 'instance creation' }
ReInlineMethodDriver >> scopes: aScope interval: anInterval selector: aSelector class: aClass [

	scopes := aScope.
	model := self refactoringScopeOn: scopes first.
	interval := anInterval.
	selector := aSelector.
	class := aClass
]
