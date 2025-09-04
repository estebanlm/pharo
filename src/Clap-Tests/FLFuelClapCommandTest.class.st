Class {
	#name : 'FLFuelClapCommandTest',
	#superclass : 'ClapPharoCommandsTest',
	#category : 'Clap-Tests-Commands',
	#package : 'Clap-Tests',
	#tag : 'Commands'
}

{ #category : 'tests' }
FLFuelClapCommandTest >> testGetManyFilesToProcessWheManyFuelFilesGivenInArguments [

	| command |
	context := FLFuelClapCommand commandSpecification activationWith: #( 'fuel' 'foo.fuel' 'bar.fuel' 'baz.fuel' 'foo.bar').
	command := context command.

	self
		assertCollection: command allFuelFiles 
		hasSameElements: #( 'foo.fuel' 'bar.fuel' 'baz.fuel' )
]

{ #category : 'tests' }
FLFuelClapCommandTest >> testGetOneFileToProcessWheOneFuelFileGivenInArguments [

	| command |
	context := FLFuelClapCommand commandSpecification activationWith: #( 'fuel' 'foo.fuel' ).
	command := context command.

	self
		assertCollection: command allFuelFiles 
		hasSameElements: #( 'foo.fuel' )
]

{ #category : 'tests' }
FLFuelClapCommandTest >> testRunningFuelWithoutFileExitsWithErrorMessage [
	context := FLFuelClapCommand commandSpecification activateWith: #('fuel').
	
	self assertFailure.
	self
		assert: context exitException messageText
		equals: 'Missing Fuel file as argument'
]
