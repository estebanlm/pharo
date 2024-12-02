Class {
	#name : 'ReExtractTempDriverTest',
	#superclass : 'ReDriverTest',
	#category : 'Refactoring-UI-Tests-Driver',
	#package : 'Refactoring-UI-Tests',
	#tag : 'Driver'
}

{ #category : 'tests' }
ReExtractTempDriverTest >> testInvalidNameAndAbandon [

	| rbclasses driver uiManager |
	rbclasses := RBClassEnvironment classes: { MyClassA }.
	driver := ReExtractTempDriver new
		          scopes: { rbclasses };
		          extract: (23 to: 24)
					from: #methodForPushDown
		          in: MyClassA.
	self setUpDriver: driver.

	uiManager := MockObject new.
	uiManager on: #request:initialAnswer:title: respond: 'instVarName1'.
	uiManager on: #request:initialAnswer:title: respond: nil.
	driver uiManager: uiManager.
	
	driver runRefactoring.
	"Renaming the references to the variable is not encapsulated in change objects, therefore the only change is the renaming of the variable itself."


	self assert: driver refactoring changes changes size equals: 0
]

{ #category : 'tests' }
ReExtractTempDriverTest >> testValidNameSuccessfulRename [

	| rbclasses driver uiManager |
	rbclasses := RBClassEnvironment classes: { MyClassA }.
	driver := ReExtractTempDriver new
		          scopes: { rbclasses };
		          extract: (23 to: 24)
					from: #methodForPushDown
		          in: MyClassA.
	self setUpDriver: driver.

	uiManager := MockObject new.
	uiManager on: #request:initialAnswer:title: respond: 'foobar'.
	driver uiManager: uiManager.
	
	driver runRefactoring.
	"Renaming the references to the variable is not encapsulated in change objects, therefore the only change is the renaming of the variable itself."


	self assert: driver refactoring changes changes size equals: 1
]
