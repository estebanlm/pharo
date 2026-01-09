"
I am a condition that tests whether a class rename will result in shadowing of the class reference by an existing shared variable that has the same name as the new class name.
"
Class {
	#name : 'ReSharedVariableShadowingClassNameCondition',
	#superclass : 'ReVariableNameCondition',
	#instVars : [
		'model',
		'oldName'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'instance creation' }
ReSharedVariableShadowingClassNameCondition class >> name: aName oldName: oldName model: aModel [

	^ (self name: aName)
		oldName: oldName
		model: aModel;
		yourself
]

{ #category : 'checking' }
ReSharedVariableShadowingClassNameCondition >> check [
	"We can't rename a class to a name of existing shared variable if
	the class that has variable defined is also referenceing class that is being renamed.
	We then change symbol lookup, and old class will resolve to shared var."
	| oldClass |
	oldClass := model classNamed: oldName.
	violator := OrderedCollection new.
	model allClassesDo: [ :cls |
		(cls definesClassVariable: name) ifTrue: [ 
			| refs |
			refs := cls whichSelectorsReferToClass: oldClass.
			refs ifNotEmpty: [ 
				violator add: cls -> refs ] ] ].
	^ violator isNil
]

{ #category : 'accessing' }
ReSharedVariableShadowingClassNameCondition >> oldName: oldClassNameString model: aModel [

	oldName := oldClassNameString.
	model := aModel
]

{ #category : 'displaying' }
ReSharedVariableShadowingClassNameCondition >> violationMessageOn: aStream [

	aStream nextPutAll: 'There is existing shared variable with name: ';
		nextPutAll: name;
		cr;
		nextPutAll: 'Renaming the class to this name will change existing symbol lookup,';
		cr;
		nextPutAll: 'since following classes and their methods reference the renaming class.';
		cr.

		violator
			asSortedCollection: [ :a :b | a key name < b key name ];
			do: [ :assoc |
				aStream
					nextPutAll: assoc key name;
					nextPutAll: ' selectors: ';
					cr.
				assoc value
					asSortedCollection: [ :m1 :m2 | m1 selector < m2 selector ];
					do: [ :method |
						aStream
							tab;
							nextPutAll: method ].
				aStream cr ]

]
