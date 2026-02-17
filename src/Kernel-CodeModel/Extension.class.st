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

	(self userPackages includes: aPackage) ifTrue: [ self error: 'Package already extended: ' , aPackage name ].

	self userPackages add: aPackage
]

{ #category : 'compiling' }
Extension >> compile: sourceCode classified: protocol withStamp: changeStamp notifying: requestor logSource: logSource recompileDependencies: recompileDependencies [
	"Return the selector of the compiled method"

	| method compiler ast scopedSelector selectorSymbol methodCopyInExtendedClass visibleExtensions |
	compiler := self compiler
		            source: sourceCode;
		            requestor: requestor;
		            failBlock: (requestor ifNotNil: [ [ ^ nil ] ]);
		            "no failblock if no requestor""compatibility: permit undeclared if no requestor"permitFaulty: requestor isNil;
		            permitUndeclared: requestor isNil;
		            protocol: protocol;
		            changeStamp: changeStamp;
		            logged: logSource.

	ast := compiler parse.

	selectorSymbol := ast selector.
	scopedSelector := self internScopedSelector: selectorSymbol.
	ast selector: scopedSelector.
	ast sendNodes do: [ :send | send selector: (OCSelectorNode value: (self package lookupSelector: send selector)) ].

	method := compiler install.
	
	"If the extension overwrites a normal method, then install a conflict method"
	visibleExtensions := scopedSelector extensionsOn: self extendedClass.
	methodCopyInExtendedClass := (self extendedClass methodDictionary includesKey: selectorSymbol)
		                             ifTrue: [
				                             ConflictMethod new
					                             overwrittenSelector: selectorSymbol;
					                             conflictingClass: self extendedClass;
					                             conflictingExtensions: visibleExtensions;
					                             yourself ]
		                             ifFalse: [
				                             visibleExtensions size > 1
					                             ifTrue: [
							                             ConflictMethod new
								                             overwrittenSelector: selectorSymbol;
								                             conflictingClass: self extendedClass;
								                             conflictingExtensions: visibleExtensions;
								                             yourself ]
					                             ifFalse: [
							                             method copy
								                             methodClass: self extendedClass;
								                             yourself ] ].

	"We install the extension in the extended class"
	methodCopyInExtendedClass propertyAt: #extensionPackage put: self package.
	self extendedClass classify: scopedSelector under: protocol.
	self extendedClass methodDict at: scopedSelector put: methodCopyInExtendedClass.
	scopedSelector addExtendedBehavior: self extendedClass.

	"Alias subclasses"
	scopedSelector bindAliasesInSubclassesOf: self extendedClass.
	
	"Update user packages so they define a locally scoped selector with the same name"
	userPackages ifNotNil: [ userPackages do: [ :e | e internScopedSelector: selectorSymbol ] ].
	recompileDependencies ifTrue: [
			| packagesToRecompile |
			packagesToRecompile := { self package }.
			userPackages ifNotNil: [ packagesToRecompile := packagesToRecompile , userPackages asArray ].
			(packagesToRecompile flatCollect: [ :p | p methods ]) do: [ :m |
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

{ #category : 'converting' }
Extension >> definedMethods [
	"Returns the methods of classes excluding the ones of the traits or extensions"

	^ self localMethods
]

{ #category : 'accessing' }
Extension >> extendedClass [

	^ extendedClass
]

{ #category : 'accessing' }
Extension >> extendedClass: anObject [

	extendedClass := anObject
]

{ #category : 'accessing' }
Extension >> internScopedSelector: aSymbol [

	^ self package internScopedSelector: aSymbol
]

{ #category : 'initialization' }
Extension >> removeFromSystem: logged [.

	self selectors do: [ :e |
		self removeSelector: e ].
	super removeFromSystem: logged
]

{ #category : 'accessing - method dictionary' }
Extension >> removeSelector: aSelector [

	super removeSelector: aSelector.
	extendedClass removeMethod: (extendedClass >> aSelector)
]

{ #category : 'accessing' }
Extension >> removeUserPackage: aPackage [

	self userPackages remove: aPackage
]

{ #category : 'accessing' }
Extension >> scopedSelectors [

	"An extension only has scoped selectors"
	^ self selectors
]

{ #category : 'initialization' }
Extension >> userPackages [

	^ userPackages ifNil: [ userPackages := IdentitySet new ].
]
