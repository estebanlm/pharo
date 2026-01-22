Class {
	#name : 'ExtensionTest',
	#superclass : 'TestCase',
	#instVars : [
		'environment',
		'userClass',
		'pointExtension',
		'userPackage',
		'definerPackage',
		'extensionOnObject',
		'definerPackage2'
	],
	#category : 'Kernel-CodeModel-Tests',
	#package : 'Kernel-CodeModel-Tests'
}

{ #category : 'running' }
ExtensionTest >> setUp [

	super setUp.
	
	environment := SystemEnvironment new.
	definerPackage := Package named: 'Definer'.
	userPackage := Package named: 'User'.
	
	extensionOnObject := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definerPackage) install.
		
	pointExtension := (Extension << #ExtensionOfPoint
		extendedClass: Point;
		installingEnvironment: environment;
		package: definerPackage) install.

	userClass := (Object << #MyUserClass
		installingEnvironment: environment;
		package: userPackage) install.
]

{ #category : 'running' }
ExtensionTest >> tearDown [

	definerPackage cleanupExtendedBehaviors.
	definerPackage2 ifNotNil: [ :p | p cleanupExtendedBehaviors].
	super tearDown.
]

{ #category : 'tests - semantic' }
ExtensionTest >> test01ExtensionKnowsExtendedClass [

	self assert: extensionOnObject extendedClass == Object
]

{ #category : 'tests - runtime' }
ExtensionTest >> test01NewScopedSelectorHasNoExternalUsers [

	| scopedSelector |		
	scopedSelector := definerPackage defineScopedSelector: #newSelector.
	
	self assert: scopedSelector extendedBehaviors isEmpty
]

{ #category : 'tests - semantic' }
ExtensionTest >> test02ExtensionIsPresentInEnvironment [

	self assert: (environment at: #ExtensionOfObject) == extensionOnObject
]

{ #category : 'tests - runtime' }
ExtensionTest >> test03LookupNonExtendedSelectorReturnsGlobalSelector [

	self assert: (userPackage lookupSelector: #maybeExtension) == #maybeExtension
]

{ #category : 'tests - runtime' }
ExtensionTest >> test04LookupExtendedSelectorInDefinerReturnsScopedSelector [

	| scopedSelector |	
	"We define a extension method, which defines a scoped selector in the selector namespace"
	extensionOnObject compile: 'extensionMethod ^ 42'.
	
	scopedSelector := definerPackage lookupSelector: #extensionMethod.
	self assert: scopedSelector isScopedSelector.
	self assert: scopedSelector symbol equals: #extensionMethod.
	self assert: scopedSelector owner equals: definerPackage.
]

{ #category : 'tests - runtime' }
ExtensionTest >> test05LookupExtendedSelectorInUserReturnsScopedSelector [

	| scopedSelector |	
	"We define a extension method, which defines a scoped selector in the selector namespace"
	extensionOnObject compile: 'extensionMethod ^ 42'.
	userPackage importExtension: extensionOnObject.
	
	scopedSelector := userPackage lookupSelector: #extensionMethod.
	self assert: scopedSelector isScopedSelector.
	self assert: scopedSelector symbol equals: #extensionMethod.
	self assert: scopedSelector owner equals: userPackage.
]

{ #category : 'tests - semantic' }
ExtensionTest >> test06ExtensionsInTheSamePackageSeeEachOther [

	| receiver |
	extensionOnObject compile: 'extension2 ^ 42'.
	extensionOnObject compile: 'extension1 ^ self extension2'.

	receiver := Object new.
	self assert: (receiver perform: (definerPackage lookupSelector: #extension1)) equals: 42
]

{ #category : 'tests - semantic' }
ExtensionTest >> test07ExtensionsInTheSamePackageSeeEachOtherIfDefinedBackwards [

	| receiver |
	extensionOnObject compile: 'extension1 ^ self extension2'.
	extensionOnObject compile: 'extension2 ^ 42'.

	receiver := Object new.
	self assert: (receiver perform: (definerPackage lookupSelector: #extension1)) equals: 42
]

{ #category : 'tests - semantic' }
ExtensionTest >> test08RecursiveExtensionSeesItself [

	| receiver |
	extensionOnObject compile: 'factorial: n ^ n == 0 ifTrue: [1] ifFalse: [n * (self factorial: n - 1)]'.
	
	receiver := Object new.
	self assert: (receiver perform: (definerPackage lookupSelector: #factorial:) with: 5) equals: 120
]

{ #category : 'tests - semantic' }
ExtensionTest >> test09ExtensionIsNotVisibleIfNotImported [

	| receiver |
	extensionOnObject compile: 'extensionMethod ^ 42'.
	userClass compile: 'userMethod ^ self extensionMethod'.
	
	receiver := userClass new.
	[receiver userMethod. self fail]
		on: MessageNotUnderstood do: [ :dnu |
			self assert: dnu receiver == receiver.
			self assert: dnu message selector equals: #extensionMethod ]
]

{ #category : 'tests - semantic' }
ExtensionTest >> test10ExtensionIsVisibleIfImported [

	| receiver |		
	extensionOnObject compile: 'extensionMethod ^ 42'.
	userClass compile: 'userMethod ^ self extensionMethod'.

	userPackage importExtension: extensionOnObject.
	
	receiver := userClass new.
	self assert: receiver userMethod equals: 42
]

{ #category : 'tests - semantic' }
ExtensionTest >> test11ExtensionsArePolymorphicWithBaseSelectors [

	| userInstance |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1@2) equals: 'youpiii'.
	self assert: (userInstance scopedUser: 1) equals: '1'.
		
	"Not visible if not imported"
	self assert: (1@2) asString equals: '(1@2)'.

]

{ #category : 'tests - runtime' }
ExtensionTest >> test12ExtensionDefinesSelectorWithExtendedClass [

	extensionOnObject compile: 'extensionMethod ^ 42'.
	
	"Now userMethod has executed, and a scoped selector for #extensionMethod has been installed in Object"
	self assert: ((definerPackage lookupSelector: #extensionMethod) extendedBehaviors includes: Object)
]

{ #category : 'tests - semantic' }
ExtensionTest >> test12ExtensionsArePolymorphicBetweenThem [

	| userInstance extensionOnInteger |
	definerPackage2 := Package named: 'Definer2'.
	extensionOnInteger := (Extension << #ExtensionOfInteger
		extendedClass: Integer;
		installingEnvironment: environment;
		package: definerPackage2) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	extensionOnInteger compile: 'foo ^ 42'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: extensionOnInteger.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1) equals: 42.
	self assert: (userInstance scopedUser: 'hola') equals: 10.
]

{ #category : 'tests - semantic' }
ExtensionTest >> test13ConflictingExtensionsThrowError [

	| userInstance anotherExtensionOnObject |
	definerPackage2 := Package named: 'Definer2'.
	anotherExtensionOnObject := (Extension << #AnotherExtensionOnObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definerPackage2) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	anotherExtensionOnObject compile: 'foo ^ 42'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: anotherExtensionOnObject.
	userInstance := userClass new.

	self should: [(userInstance scopedUser: 1)] raise: ExtensionConflict with: [ :ex | self assert: ex messageText equals: 'Conflict extending #foo in Object' ].
	
]

{ #category : 'tests - runtime' }
ExtensionTest >> test13ExtensionDoesNotDefineAliasBeforeSend [

	| userInstance scopedSelector |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.
	
	scopedSelector := userPackage lookupSelector: #asString.
	self assert: scopedSelector isScopedSelector.
	self assert: (1 class lookupSelector: scopedSelector) isNil
]

{ #category : 'tests - runtime' }
ExtensionTest >> test14DefinerAndUserSelectorAreNotTheSame [

	| definerScopedSelector userScopedSelector |
	pointExtension compile: 'asString ^ ''youpiii'''.

	userPackage importExtension: pointExtension.
	
	definerScopedSelector := definerPackage lookupSelector: #asString.
	userScopedSelector := userPackage lookupSelector: #asString.

	self deny: definerScopedSelector == userScopedSelector
]

{ #category : 'tests - semantic' }
ExtensionTest >> test14ExtensionSuperSends [

	| userInstance extensionOnInteger |
	extensionOnInteger := (Extension << #ExtensionOfInteger
		extendedClass: Integer;
		installingEnvironment: environment;
		package: definerPackage) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	extensionOnInteger compile: 'foo ^ super foo + 1'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: extensionOnInteger.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1) equals: 11.
	self assert: (userInstance scopedUser: 'hola') equals: 10.
]

{ #category : 'tests - semantic' }
ExtensionTest >> test15ExtensionsInHierarchySubclassBindingFirst [

	| userInstance extensionOnInteger |
	extensionOnInteger := (Extension << #ExtensionOfInteger
		extendedClass: Integer;
		installingEnvironment: environment;
		package: definerPackage) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	extensionOnInteger compile: 'foo ^ 42'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: extensionOnInteger.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1) equals: 42.
	self assert: (userInstance scopedUser: 'hola') equals: 10.

]

{ #category : 'tests - semantic' }
ExtensionTest >> test15ExtensionsInHierarchySuperclassBindingFirst [

	| userInstance extensionOnInteger |
	extensionOnInteger := (Extension << #ExtensionOfInteger
		extendedClass: Integer;
		installingEnvironment: environment;
		package: definerPackage) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	extensionOnInteger compile: 'foo ^ 42'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: extensionOnInteger.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 'hola') equals: 10.
	self assert: (userInstance scopedUser: 1) equals: 42.
]

{ #category : 'tests - semantic' }
ExtensionTest >> test15ExtensionsWithIsolatedSuperSends [

	| userInstance extensionOnInteger superSenderSelector |
	definerPackage2 := Package named: 'Definer2'.
	extensionOnInteger := (Extension << #ExtensionOfInteger
		extendedClass: Integer;
		installingEnvironment: environment;
		package: definerPackage2) install.
	
	extensionOnObject compile: 'foo ^ 10'.
	superSenderSelector := extensionOnInteger compile: 'foo ^ super foo + 1'.
	userClass compile: 'scopedUser: anObject
		^ anObject foo'.

	userPackage importExtension: extensionOnObject.
	userPackage importExtension: extensionOnInteger.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 'hola') equals: 10.
	
	self should: [userInstance scopedUser: 1] raise: MessageNotUnderstood with: [ :dnu |
		self assert: dnu receiver equals: 1.
		self assert: dnu message selector equals: (extensionOnInteger package lookupSelector: #foo).
		"I don't like the sender sender sender"
		self assert: dnu signalerContext sender sender sender method == (Integer >> superSenderSelector) ]

]

{ #category : 'tests - runtime' }
ExtensionTest >> test15LookupAliasedSelectorInUserReturnsExtensionMethod [

	| definerScopedSelector userScopedSelector method1 method2 |
	pointExtension compile: 'asString ^ ''youpiii'''.

	userPackage importExtension: pointExtension.
	
	definerScopedSelector := definerPackage lookupSelector: #asString.
	userScopedSelector := userPackage lookupSelector: #asString.
	method1 := userScopedSelector lookupAliasedMethodOnReceiverClass: Point.
	method2 := definerScopedSelector lookupAliasedMethodOnReceiverClass: Point.

	self assert: method1 second == method2 second
]

{ #category : 'tests - runtime' }
ExtensionTest >> test16ExtensionDoesNotTrackAliasedClassBeforeSend [

	| userInstance scopedSelector |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.
	
	scopedSelector := userPackage lookupSelector: #asString.
	self deny: (scopedSelector extendedBehaviors includes: 1 class)
]

{ #category : 'tests - runtime' }
ExtensionTest >> test17ExtensionDefinesAliasAfterSend [

	| userInstance scopedSelector asStringOriginalDefiner |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.

	"This sends a scoped message to a non extended class.
	The lookup will find the global selector and alias it to the scoped one."
	self assert: (userInstance scopedUser: 1) equals: '1'.
	
	scopedSelector := userPackage lookupSelector: #asString.
	asStringOriginalDefiner := (Integer lookupSelector: #asString) methodClass.
	self assert: (scopedSelector extendedBehaviors includes: asStringOriginalDefiner)
]

{ #category : 'tests - runtime' }
ExtensionTest >> test18CleanExtendedBehaviorsCleansExtensionMethods [

	| scopedSelector |
	scopedSelector := extensionOnObject compile: 'extensionMethod ^ 42'.
	self assert: scopedSelector isScopedSelector.

	self assert: (1 perform: (scopedSelector)) equals: 42.
	
	definerPackage cleanupExtendedBehaviors.
	
	self deny: (1 respondsTo: scopedSelector)
]

{ #category : 'tests - runtime' }
ExtensionTest >> test18ExtensionTracksAliasedClassAfterSend [

	| userInstance scopedSelector originalAsStringDefiner |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1) equals: '1'.
	
	scopedSelector := userPackage lookupSelector: #asString.
	originalAsStringDefiner := (1 class lookupSelector: #asString) methodClass.
	self assert: (scopedSelector extendedBehaviors includes: originalAsStringDefiner)
]

{ #category : 'tests - runtime' }
ExtensionTest >> test19CleanExtendedBehaviorsRemovesTrackedBehaviors [

	| receiver scopedSelector |
	extensionOnObject compile: 'extensionMethod ^ 42'.
	userClass compile: 'userMethod ^ self extensionMethod'.

	userPackage importExtension: extensionOnObject.

	receiver := userClass new.
	receiver userMethod.

	scopedSelector := definerPackage lookupSelector: #extensionMethod.
	definerPackage cleanupExtendedBehaviors.

	self assert: scopedSelector extendedBehaviors isEmpty
]

{ #category : 'tests - runtime' }
ExtensionTest >> test20CleanExtendedBehaviorsCleansAliases [

	| userInstance scopedSelector |
	pointExtension compile: 'asString ^ ''youpiii'''.
	userClass compile: 'scopedUser: anObject
		^ anObject asString'.

	userPackage importExtension: pointExtension.
	userInstance := userClass new.

	self assert: (userInstance scopedUser: 1) equals: '1'.
	
	scopedSelector := userPackage lookupSelector: #asString.
	definerPackage cleanupExtendedBehaviors.
	
	self deny: (scopedSelector extendedBehaviors includes: Integer)
]
