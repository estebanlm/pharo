"
Verifies that a given selector is defined in the hierarchy of a given class (including the class itself and excluding Object).
Violators are classes in the hierarchy defining the selector.
"
Class {
	#name : 'ReDefinesSelectorInHierarchyCondition',
	#superclass : 'ReMethodsCondition',
	#instVars : [
		'class',
		'selector'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'initialization' }
ReDefinesSelectorInHierarchyCondition >> definesSelector: aSelector in: aClass [

	class := aClass.
	selector := aSelector
]

{ #category : 'accessing' }
ReDefinesSelectorInHierarchyCondition >> nonViolators [

	^ (class withAllSuperclassesUntil: Object) reject: [ :cls | violators contains: cls ]
]

{ #category : 'displaying' }
ReDefinesSelectorInHierarchyCondition >> violationMessageOn: aStream [

	self violators do: [ :violator |
		aStream
			nextPutAll: selector;
			nextPutAll: ' is not defined in the class ';
			nextPutAll: violator name;
			nextPutAll: '.';
			space ].
	aStream nextPutAll: 'Selectors must be defined in the class.'
]

{ #category : 'accessing' }
ReDefinesSelectorInHierarchyCondition >> violators [

	^ violators ifNil: [
		  violators := (class withAllSuperclassesUntil: Object) reverse select: [ :aClass | aClass directlyDefinesMethod: selector ] ]
]
