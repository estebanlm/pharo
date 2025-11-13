Class {
	#name : 'ReMultipleMethodsDontReferToTempVarsCondition',
	#superclass : 'ReVariableNameCondition',
	#instVars : [
		'class',
		'selector'
	],
	#category : 'Refactoring-Core-Conditions',
	#package : 'Refactoring-Core',
	#tag : 'Conditions'
}

{ #category : 'instance creation' }
ReMultipleMethodsDontReferToTempVarsCondition class >> name: aString class: aClass selector: aSelector [

	^ (self name: aString)
		  class: aClass;
		  selector: aSelector yourself
]

{ #category : 'checking' }
ReMultipleMethodsDontReferToTempVarsCondition >> check [

	^ self violators isEmpty
]

{ #category : 'setter' }
ReMultipleMethodsDontReferToTempVarsCondition >> class: aRBClass [ 

	class := aRBClass.

]

{ #category : 'utilities' }
ReMultipleMethodsDontReferToTempVarsCondition >> multipleMethodsDefiningTemporary: aString in: aClass ignore: aBlock [

	| searcher methods method |
	searcher := OCParseTreeSearcher new.
	methods := Set new.
	method := nil.

	searcher matches: aString do: [ :aNode :answer | methods add: method ].
	aClass withAllSubclasses do: [ :cls |
			cls selectors do: [ :each |
					(aBlock value: cls value: each) ifFalse: [
							| parseTree |
							method := cls methodFor: each.
							parseTree := cls parseTreeForSelector: each.
							parseTree ifNotNil: [ searcher executeTree: parseTree ] ] ] ].
	^ methods
]

{ #category : 'accessing' }
ReMultipleMethodsDontReferToTempVarsCondition >> selector: aSelector [

	selector := aSelector
]

{ #category : 'displaying' }
ReMultipleMethodsDontReferToTempVarsCondition >> violationMessageOn: aStream [

	self violators ifEmpty: [ ^ self ].
	^ aStream
		  nextPutAll: 'More than one method defines temporary variable ';
		  nextPutAll: name;
		  nextPutAll: ': ';
		  nextPutAll: (self violators collect: [ :m | m selector ]) asArray asString
]

{ #category : 'checking' }
ReMultipleMethodsDontReferToTempVarsCondition >> violators [

	| methods |
	methods := self multipleMethodsDefiningTemporary: name in: class ignore: [ :cls :selectors | false ].
	^ methods reject: [ :m | m selector = selector ]
]
