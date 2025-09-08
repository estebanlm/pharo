Class {
	#name : 'SaveCliCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'context'
	],
	#category : 'System-BasicCommandLineHandler-Tests-Commands',
	#package : 'System-BasicCommandLineHandler-Tests',
	#tag : 'Commands'
}

{ #category : 'tests' }
SaveCliCommandTest >> testShoudlDeleteOldImageWhenDeleteOldFlagPresent [
	| command |
	context := SaveCliCommand commandSpecification activationWith: #('save' '--delete-old').
	command := context command.
	
	self assert: command shouldDeleteOldImage
]

{ #category : 'tests' }
SaveCliCommandTest >> testShoudlNotDeleteOldImageWhenDeleteOldFlagAbsent [
	| command |
	context := SaveCliCommand commandSpecification activationWith: #('save').
	command := context command.
	
	self deny: command shouldDeleteOldImage
]
