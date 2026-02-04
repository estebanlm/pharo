Class {
	#name : 'ExtensionHotUpdateTest',
	#superclass : 'TestCase',
	#instVars : [
		'environment',
		'definerPackage',
		'userPackage',
		'objectClass',
		'pointClass',
		'extensionOnPoint',
		'extensionOnObject',
		'userClass',
		'coloredPointClass',
		'extensionOnColoredPoint',
		'stringClass',
		'nicerStringClass'
	],
	#category : 'Kernel-CodeModel-Tests-Extensions',
	#package : 'Kernel-CodeModel-Tests',
	#tag : 'Extensions'
}

{ #category : 'running' }
ExtensionHotUpdateTest >> setUp [

	| extendedPackage |
	super setUp.
	
	environment := SystemEnvironment new.
	extendedPackage := Package named: 'Extended'.
	definerPackage := Package named: 'Definer'.
	userPackage := Package named: 'User'.

	objectClass := (Object << #MyObject
		installingEnvironment: environment;
		package: userPackage) install.
	
	pointClass := (Object << #MyPoint
		superclass: objectClass;
		installingEnvironment: environment;
		package: userPackage) install.

	coloredPointClass := (Object << #MyColoredPoint
		superclass: pointClass;
		installingEnvironment: environment;
		package: userPackage) install.
	
	"String will have no extensions. It's here just for polymorphism.
	It will thus contain aliases only"
	stringClass := (Object << #MyString
		superclass: objectClass;
		installingEnvironment: environment;
		package: userPackage) install.
	
	nicerStringClass := (Object << #MyNicerString
		superclass: stringClass;
		installingEnvironment: environment;
		package: userPackage) install.

	userClass := (Object << #MyUserClass
		superclass: objectClass;
		installingEnvironment: environment;
		package: userPackage) install.
	
	extensionOnObject := (Extension << #ExtensionOfObject
		extendedClass: objectClass;
		installingEnvironment: environment;
		package: definerPackage) install.

	extensionOnPoint := (Extension << #ExtensionOfPoint
		extendedClass: pointClass;
		installingEnvironment: environment;
		package: definerPackage) install.

	extensionOnColoredPoint := (Extension << #ExtensionOfColoredPoint
		extendedClass: coloredPointClass;
		installingEnvironment: environment;
		package: definerPackage) install.
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test01CompileNewExtensionMethod01InstallsExtensionInExtendedClass [

	| scopedSelector |
	scopedSelector := extensionOnObject compile: 'extension ^ 42'.
	
	self assert: (objectClass new perform: scopedSelector) equals: 42
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test01CompileNewExtensionMethod02InstallsAliasInSubclasses [

	"Point defines a normal method"
	| scopedSelector |
	pointClass compile: 'extension ^ 17'.
	
	"We extend the superclass with the same selector"
	scopedSelector := extensionOnObject compile: 'extension ^ 42'.
	
	
	self assert: (pointClass new perform: scopedSelector) equals: 17
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test01CompileNewExtensionMethod03InstallsAliasInSubclassesButStopsAtFrontier [

	| scopedSelector |
	
	"Point defines a normal method that should be aliased"
	pointClass compile: 'extension ^ 17'.
	extensionOnColoredPoint compile: 'extension ^ 73'.
	
	"We extend the superclass with the same selector"
	scopedSelector := extensionOnObject compile: 'extension ^ 42'.
	
	self assert: (pointClass new perform: scopedSelector) equals: 17.
	self assert: (coloredPointClass new perform: scopedSelector) equals: 73.
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test02OverrideAliasWithNormalMethod01ShouldAliasNewMethod [

	| scopedSelector |
	"We extend Point"
	scopedSelector := extensionOnPoint compile: 'extension ^ 11'.
	"String defines a normal method with the same selector name, global"
	stringClass compile: 'extension ^ 42'.
	
	"We send a message to a string to alias the method"
	self assert: (stringClass new perform: scopedSelector) equals: 42.
	
	"Now we override #extension in MyNicerString and that should automatically alias it!"
	nicerStringClass compile: 'extension ^ 73'.
	
	self assert: (nicerStringClass new perform: scopedSelector) equals: 73
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test02OverrideExtensionWithNormalMethod01ShouldAliasNewMethod [

	| scopedSelector |
	"We extend Object"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.
	
	"Now we override the extension.
	This should alias the one in the superclass: the scoped selector should see this method"
	pointClass compile: 'extension ^ 42'.
	
	self assert: (pointClass new perform: scopedSelector) equals: 42
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test03RemoveExtension01ShouldRemoveExtensionMethod [

	| scopedSelector receiver |
	"We extend Object"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.
	
	"Now we remove the extension"
	extensionOnObject removeSelector: scopedSelector.
	
	"So the message is not understood anymore"
	receiver := objectClass new.
	self
		should: [ receiver perform: scopedSelector ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :dnu |
			self assert: dnu receiver equals: receiver.
			self assert: dnu message selector equals: scopedSelector ]
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test03RemoveExtension02ShouldRemoveAliasesToExtensionInTheExtendedClass [

	| extensionScopedSelector receiver userScopedSelector |
	"We extend Object"
	extensionScopedSelector := extensionOnObject compile: 'extension ^ 11'.
	
	"We import and use the extension, which will generate an alias"
	userPackage importExtension: extensionOnObject.
	userClass compile: 'userMethod: anObject ^ anObject extension'.
	userScopedSelector := userPackage lookupSelector: #extension.
	
	"Send the message to create the alias"
	userClass new userMethod: objectClass new.
	
	"Now we remove the extension"
	extensionOnObject removeSelector: extensionScopedSelector.
	
	"So the message is not understood anymore"
	receiver := objectClass new.
	
	"Not from the package itself"
	self
		should: [ receiver perform: extensionScopedSelector ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :dnu |
			self assert: dnu receiver equals: receiver.
			self assert: dnu message selector equals: extensionScopedSelector ].
	
	"Nor from the user alias"
	self
		should: [ receiver perform: userScopedSelector ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :dnu |
			self assert: dnu receiver equals: receiver.
			self assert: dnu message selector equals: userScopedSelector ]
]

{ #category : 'tests' }
ExtensionHotUpdateTest >> test03RemoveExtension03ShouldNotRemoveUnrelatedAliases [

	| extensionScopedSelector receiver userScopedSelector definerPackage2 extensionOnObject2 userPackage2 extensionScopedSelector2 userScopedSelector2 |
	"Complex setup.
	We have two packages defining extensions (def1, def2).
	Two users (user1, user2).
	Each user uses only one extension, and thus has an alias to it.
	
	We remove one of the extensions: def1.
	This should not impact def2.
	"

	"First package already exists.
	Add extension method, import, send to alias"
	extensionOnObject compile: 'extension ^ 25'.
	userPackage importExtension: extensionOnObject.
	extensionScopedSelector := definerPackage lookupSelector: #extension.
	userScopedSelector := userPackage lookupSelector: #extension.
	objectClass new perform: userScopedSelector.

	"Second package.
	Create package and extension"
	definerPackage2 := Package named: 'Definer2'.
	extensionOnObject2 := (Extension << #ExtensionOfObject2
		extendedClass: objectClass;
		installingEnvironment: environment;
		package: definerPackage2) install.
	
	"Add extension method, import, send to alias"
	extensionOnObject2 compile: 'extension ^ 17'.
	userPackage2 := Package named: 'User2'.
	userPackage2 importExtension: extensionOnObject2.
	extensionScopedSelector2 := definerPackage2 lookupSelector: #extension.
	userScopedSelector2 := userPackage2 lookupSelector: #extension.
	objectClass new perform: userScopedSelector2.
	
	"Now we remove the extension from the definer package 1"
	extensionOnObject removeSelector: extensionScopedSelector.
	
	receiver := objectClass new.
	
	"So the message from definer package 1 is not understood anymore"
	self
		should: [ receiver perform: extensionScopedSelector ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :dnu |
			self assert: dnu receiver equals: receiver.
			self assert: dnu message selector equals: extensionScopedSelector ].
	
	"Nor from the user 1 alias"
	self
		should: [ receiver perform: userScopedSelector ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :dnu |
			self assert: dnu receiver equals: receiver.
			self assert: dnu message selector equals: userScopedSelector ].
		
	"But it should still understand the messages from the definer package 2 and its user"
	self assert: (receiver perform: extensionScopedSelector2) equals: 17.
	self assert: (receiver perform: userScopedSelector2) equals: 17.
]
