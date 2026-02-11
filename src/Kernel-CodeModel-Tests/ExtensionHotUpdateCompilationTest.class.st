Class {
	#name : 'ExtensionHotUpdateCompilationTest',
	#superclass : 'TestCase',
	#instVars : [
		'environment',
		'definerPackage',
		'userPackage',
		'objectClass',
		'pointClass',
		'coloredPointClass',
		'stringClass',
		'nicerStringClass',
		'userClass',
		'extensionOnObject',
		'extensionOnPoint',
		'extensionOnColoredPoint'
	],
	#category : 'Kernel-CodeModel-Tests-Extensions',
	#package : 'Kernel-CodeModel-Tests',
	#tag : 'Extensions'
}

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> assertDNU: scopedSelector on: selector to: receiver [
	
	
	self should: [ receiver perform: selector ] raise: MessageNotUnderstood withExceptionDo: [ :ex |
		self assert: ex receiver == receiver.
		self assert: ex message selector == scopedSelector. ]
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> setUp [

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
ExtensionHotUpdateCompilationTest >> test01CompileNewExtensionMethod01IsVisibleForNewMethods [

	"A normal method sends the (non scoped) extension message"
	| classInDefinerPackage |
	classInDefinerPackage := (Object << #ClassInDefinerPackage
		superclass: objectClass;
		installingEnvironment: environment;
		package: definerPackage) install.

	"Now we define an extension in the scope.
	=> the method above (foo) should see the extension!"
	extensionOnObject compile: 'extension ^ 11'.

	classInDefinerPackage compile: 'foo ^ self extension'.	
	self assert: classInDefinerPackage new foo equals: 11
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> test01CompileNewExtensionMethod02RecompilesSendersInScope [

	"A normal method sends the (non scoped) extension message"
	| classInDefinerPackage |
	classInDefinerPackage := (Object << #ClassInDefinerPackage
		superclass: objectClass;
		installingEnvironment: environment;
		package: definerPackage) install.
	classInDefinerPackage compile: 'foo ^ self extension'.

	"Before compiling the extension, we do not see a scoped selector. We DNU on the global selector"
	self assertDNU: #extension on: #foo to: classInDefinerPackage new.

	"Now we define an extension in the scope.
	=> the method above (foo) should see the extension!"
	extensionOnObject compile: 'extension ^ 11'.
	
	self assert: classInDefinerPackage new foo equals: 11
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> test02ImportNewExtensionMethod01IsVisibleForNewMethods [

	"A normal method sends the (non scoped) extension message"
	| scopedSelector |
	"Now we import an extension in the scope.
	=> the method above (foo) should see the extension!"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.
	
	userClass package importExtension: extensionOnObject.

	userClass compile: 'foo ^ self extension'.
	self assert: userClass new foo equals: 11
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> test02ImportNewExtensionMethod02RecompilesSendersInScope [

	"A normal method sends the (non scoped) extension message"
	| scopedSelector |
	userClass compile: 'foo ^ self extension'.

	"Now we import an extension in the scope.
	=> the method above (foo) should see the extension!"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.
	
	"Before importing the extension, we do not see a scoped selector. We DNU on the global selector"
	self assertDNU: #extension on: #foo to: userClass new.
	
	userClass package importExtension: extensionOnObject.

	self assert: userClass new foo equals: 11
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> test03CompileNewExtensionMethodAfterImport01IsVisibleForNewMethods [

	"A normal method sends the (non scoped) extension message"
	| scopedSelector |	
	
	"We import an extension in the scope. The extension is empty"
	userClass package importExtension: extensionOnObject.

	"=> the method above (foo) should see the extension!"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.

	userClass compile: 'foo ^ self extension'.
	self assert: userClass new foo equals: 11
]

{ #category : 'tests' }
ExtensionHotUpdateCompilationTest >> test03CompileNewExtensionMethodAfterImport02RecompilesSendersInScope [

	"A normal method sends the (non scoped) extension message"
	| scopedSelector |	
	
	"We import an extension in the scope. The extension is empty"
	userClass package importExtension: extensionOnObject.

	userClass compile: 'foo ^ self extension'.

	"=> the method above (foo) should see the extension!"
	scopedSelector := extensionOnObject compile: 'extension ^ 11'.
	self assert: userClass new foo equals: 11
]
