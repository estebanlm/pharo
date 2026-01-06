Class {
	#name : 'Extension',
	#superclass : 'Class',
	#instVars : [
		'extendedClass',
		'userPackages'
	],
	#category : 'Kernel-CodeModel-Extensions',
	#package : 'Kernel-CodeModel',
	#tag : 'Extensions'
}

{ #category : 'accessing' }
Extension >> addUserPackage: aPackage [

	(self userPackages includes: aPackage) ifTrue: [ self error: 'Package already extended: ', aPackage name ].
	
	self userPackages add: aPackage.
	aPackage methods do: [:m | m recompile ].
]

{ #category : 'initialization' }
Extension >> compile: sourceCode classified: protocol withStamp: changeStamp notifying: requestor logSource: logSource recompileDependencies: recompileDependencies [
	"Return the selector of the compiled method"

	| method compiler ast scopedSelector selectorSymbol methodCopyInExtendedClass |
	
	(sourceCode beginsWith: 'methodSelectorAndArgumentNames')
		ifTrue: [ self halt ].
	
	compiler := self compiler
		            source: sourceCode;
		            requestor: requestor;
		            failBlock: (requestor ifNotNil: [ [ ^ nil ] ]); "no failblock if no requestor"
						permitUndeclared: requestor isNil; "compatibility: permit undeclared if no requestor"
						protocol: protocol;
		            changeStamp: changeStamp;
		            logged: logSource.

	ast := compiler parse.
	selectorSymbol := ast selector.
	scopedSelector := self defineScopedSelector: selectorSymbol.
	ast selector: scopedSelector.
	ast sendNodes do: [ :send | send selector: (OCSelectorNode value: (self package lookupSelector: send selector)) ].

	method := compiler install.

	methodCopyInExtendedClass := method copy.
	methodCopyInExtendedClass methodClass: self extendedClass.
	self extendedClass classify: scopedSelector under: protocol.
	self extendedClass methodDict at: scopedSelector put: methodCopyInExtendedClass.

	recompileDependencies ifTrue: [
			self package methods do: [ :m |
					m methodClass
						compile: m sourceCode
						classified: m protocol
						withStamp: changeStamp
						notifying: requestor
						logSource: logSource
						recompileDependencies: false ] ].

	^ method selector
]

{ #category : 'accessing' }
Extension >> defineScopedSelector: aSymbol [

	^ self package defineScopedSelector: aSymbol
]

{ #category : 'accessing' }
Extension >> extendedClass [

	^ extendedClass
]

{ #category : 'accessing' }
Extension >> extendedClass: anObject [

	extendedClass := anObject
]

{ #category : 'initialization' }
Extension >> userPackages [

	^ userPackages ifNil: [ userPackages := IdentitySet new ].
]
