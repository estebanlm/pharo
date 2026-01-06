Class {
	#name : 'ExtensionTest',
	#superclass : 'TestCase',
	#category : 'Kernel-Extensions',
	#package : 'Kernel',
	#tag : 'Extensions'
}

{ #category : 'tests' }
ExtensionTest >> testExtensionIsNotVisibleIfNotImported [

	| definer user environment extension userClass receiver |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.
	
	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.

	userClass := (Object << #MyUserClass
		installingEnvironment: environment;
		package: user) install.
		
	extension compile: 'extensionMethod ^ 42'.
	userClass compile: 'userMethod ^ self extensionMethod'.
	
	receiver := userClass new.
	[receiver userMethod. self fail]
		on: MessageNotUnderstood do: [ :dnu |
			self assert: dnu receiver == receiver.
			self assert: dnu message selector equals: #extensionMethod ]
]

{ #category : 'tests' }
ExtensionTest >> testExtensionIsPresentInEnvironment [

	| definer user environment extension |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.

	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.

	self assert: (environment at: #ExtensionOfObject) == extension
]

{ #category : 'tests' }
ExtensionTest >> testExtensionIsVisibleIfImported [

	| definer user environment extension userClass receiver |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.
	
	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.

	userClass := (Object << #MyUserClass
		installingEnvironment: environment;
		package: user) install.
		
	extension compile: 'extensionMethod ^ 42'.
	userClass compile: 'userMethod ^ self extensionMethod'.

	user importExtension: extension.
	
	receiver := userClass new.
	self assert: receiver userMethod equals: 42
]

{ #category : 'tests' }
ExtensionTest >> testExtensionKnowsExtendedClass [

	| definer user environment extension |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.

	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.

	self assert: extension extendedClass == Object
]

{ #category : 'tests' }
ExtensionTest >> testExtensionsInTheSamePackageSeeEachOther [

	| definer environment extension receiver |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.

	extension := ((Extension << #ExtensionOfObject)
		              extendedClass: Object;
		              installingEnvironment: environment;
		              package: definer) install.

	extension compile: 'extension2 ^ 42'.
	extension compile: 'extension1 ^ self extension2'.

	receiver := Object new.
	self assert: (receiver perform: (definer lookupSelector: #extension1)) equals: 42
]

{ #category : 'tests' }
ExtensionTest >> testExtensionsInTheSamePackageSeeEachOtherIfDefinedBackwards [

	| definer environment extension receiver |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.

	extension := ((Extension << #ExtensionOfObject)
		              extendedClass: Object;
		              installingEnvironment: environment;
		              package: definer) install.

	extension compile: 'extension1 ^ self extension2'.
	extension compile: 'extension2 ^ 42'.

	receiver := Object new.
	self assert: (receiver perform: (definer lookupSelector: #extension1)) equals: 42
]

{ #category : 'tests' }
ExtensionTest >> testLookupExtendedSelectorInDefinerReturnsScopedSelector [

	| definer user environment extension scopedSelector |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.
	
	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.
	
	"We define a extension method, which defines a scoped selector in the selector namespace"
	extension compile: 'extensionMethod ^ 42'.
	
	scopedSelector := definer lookupSelector: #extensionMethod.
	self assert: scopedSelector isScopedSelector.
	self assert: scopedSelector symbol equals: #extensionMethod.
	self assert: scopedSelector owner equals: definer.
]

{ #category : 'tests' }
ExtensionTest >> testLookupExtendedSelectorInUserReturnsScopedSelector [

	| definer user environment extension scopedSelector |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	user := Package named: 'User'.
	
	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.
	
	"We define a extension method, which defines a scoped selector in the selector namespace"
	extension compile: 'extensionMethod ^ 42'.
	user importExtension: extension.
	
	scopedSelector := user lookupSelector: #extensionMethod.
	self assert: scopedSelector isScopedSelector.
	self assert: scopedSelector symbol equals: #extensionMethod.
	self assert: scopedSelector owner equals: definer.
]

{ #category : 'tests' }
ExtensionTest >> testLookupNonExtendedSelectorReturnsGlobalSelector [

	| user |
	user := Package named: 'User'.

	self assert: (user lookupSelector: #maybeExtension) == #maybeExtension
]

{ #category : 'tests' }
ExtensionTest >> testRecursiveExtensionSeesItself [

	| definer environment extension receiver |
	environment := SystemEnvironment new.
	definer := Package named: 'Definer'.
	
	extension := (Extension << #ExtensionOfObject
		extendedClass: Object;
		installingEnvironment: environment;
		package: definer) install.

	extension compile: 'factorial: n ^ n == 0 ifTrue: [1] ifFalse: [n * (self factorial: n - 1)]'.
	
	receiver := Object new.
	self assert: (receiver perform: (definer lookupSelector: #factorial:) with: 5) equals: 120
]
