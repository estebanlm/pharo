Class {
	#name : 'ReInsertSubclassDriverTest',
	#superclass : 'ReDriverTest',
	#instVars : [
		'testingEnvironment'
	],
	#category : 'Refactoring-UI-Tests-Driver',
	#package : 'Refactoring-UI-Tests',
	#tag : 'Driver'
}

{ #category : 'tests' }
ReInsertSubclassDriverTest >> newSubclassName [

	^ #ReChangeMock
]

{ #category : 'running' }
ReInsertSubclassDriverTest >> setUp [

	super setUp.
	testingEnvironment := RBClassEnvironment classes: { self superclassToAddSubclass} 
]

{ #category : 'tests' }
ReInsertSubclassDriverTest >> superclassToAddSubclass [
	"Answer the <Class> which will be subclassed"
	
	^ RBRootClassForInsertingSubclasses 
]

{ #category : 'running' }
ReInsertSubclassDriverTest >> tearDown [

	(testingEnvironment notNil and: [ testingEnvironment classNames includes: self newSubclassName ])
		ifTrue: [ testingEnvironment removeClass: self newSubclassName ].
	super tearDown.
]

{ #category : 'tests' }
ReInsertSubclassDriverTest >> testAddSingleSubclass [

	| driver rbClass |

	driver := ReAddSubclassDriver basicNew. 
	self setUpDriver: driver.
	driver 
		superclass: self superclassToAddSubclass;
		scopes: { testingEnvironment };
		subclass: self newSubclassName.
	rbClass := driver superclass.
	self deny: rbClass hasSubclasses.

	driver runRefactoring.
	
	self 
		assert: driver refactoring changes changes size 
		equals: 1.
	self
		assertCollection: (rbClass subclasses collect: #name)
		hasSameElements: { self newSubclassName }.
]

{ #category : 'tests' }
ReInsertSubclassDriverTest >> testAddSingleSubclassToDifferentPackage [

	| driver |

	driver := ReAddSubclassDriver basicNew. 
	self setUpDriver: driver.

	driver	
		superclass: self superclassToAddSubclass name;
		subclass: self newSubclassName;
		scopes: { testingEnvironment };
		packageName: ReAddSubclassDriver packageName;	
		runRefactoring.
	
	self 
		assert: driver refactoring changes changes size 
		equals: 1.
	self
		assert: driver refactoring changes changes first package
		equals: ReAddSubclassDriver packageName
]

{ #category : 'tests' }
ReInsertSubclassDriverTest >> testInsertSubclass [

	| driver rbClass |

	driver := ReInsertSubclassDriver new. 
	self setUpDriver: driver.
	driver 
		superclass: self superclassToAddSubclass;
		scopes: { testingEnvironment };
		subclass: self newSubclassName.
	
	rbClass := driver superclass.
	
	self assert: rbClass subclasses size equals: 2.

	driver runRefactoring.
	
	self 
		assert: driver refactoring changes changes size 
		equals: 1.
		

	self assert: rbClass subclasses first name equals: self newSubclassName
]
