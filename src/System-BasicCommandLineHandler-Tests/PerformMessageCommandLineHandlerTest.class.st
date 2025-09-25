Class {
	#name : 'PerformMessageCommandLineHandlerTest',
	#superclass : 'TestCase',
	#category : 'System-BasicCommandLineHandler-Tests-Base',
	#package : 'System-BasicCommandLineHandler-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> performCommandWithArguments: aCollection [

	^ PerformMessageCommandLineHandler new 
		commandLine: (CommandLineArguments withArguments: aCollection);
		yourself
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testCanGetCommandOptionsWhenCommandOptionSpecified [

	| command |
	command := self performCommandWithArguments: #('--pass-raw-arguments' '--' 'Object' 'foo' '1' 'bar').
	
	command parseCommandOptions.
	
	self assert: command commandOptions equals: #('--pass-raw-arguments').
	self assert: command commandArguments equals: #('Object' 'foo' '1' 'bar').
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testCanGetCommandOptionsWhenNoCommandOptionSpecified [

	| command |
	command := self performCommandWithArguments: #('Object' 'foo' '1' 'bar').
	
	command parseCommandOptions.
	
	self assert: command commandOptions isEmpty.
	self assert: command commandArguments equals: #('Object' 'foo' '1' 'bar').
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testCanGetTargetAndSelector [

	| command |
	command := self performCommandWithArguments: #('Object' 'foo').
	
	command parseArguments.
	
	self assert: command targetClass equals: Object.
	self assert: command message equals: #foo.
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testCanGetTargetAndSelectorWithArguments [

	| command |
	command := self performCommandWithArguments: #('--pass-raw-arguments' '--' 'Object' 'foo' '1' 'bar').
	
	command parseArguments.
	
	self assert: command targetClass equals: Object.
	self assert: command message equals: #foo.
	self assert: command messageArguments equals: #('1' 'bar').
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testCanGetTargetAndSelectorWithArrayOfArguments [

	| command |
	command := self performCommandWithArguments: #('Object' 'foo' '1' 'bar').
	
	command parseArguments.
	
	self assert: command targetClass equals: Object.
	self assert: command message equals: #foo.
	self assert: command messageArguments equals: #( #('1' 'bar') ).
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testMessageArgumentsIsAnArrayOfProvidedArgumentsWhenRawArgumentsFlagPresent [

	| command |
	command := self performCommandWithArguments: #('--pass-raw-arguments' '--' 'Object' 'foo' '1' 'bar').
	
	command parseArguments.
	
	self assert: command messageArguments equals: #('1' 'bar').
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testMessageArgumentsIsAnArrayWithOneElementBeingAnArrayOfProvidedArguments [

	| command |
	command := self performCommandWithArguments: #('Object' 'foo' '1' 'bar').
	
	command parseArguments.
	
	self assert: command messageArguments equals: #( #('1' 'bar') ).
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testMessageArgumentsIsAnEmptyArrayWhenNoArgumentProvided [

	| command |
	command := self performCommandWithArguments: #('--bar' '--' 'Object' 'foo').
	
	command parseArguments.
	
	self assert: command messageArguments equals: #( #() ).
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testMessageArgumentsIsAnEmptyArrayWhenNoArgumentProvidedAndRawArgumentsFlagPresent [

	| command |
	command := self performCommandWithArguments: #('--pass-raw-arguments' '--' 'Object' 'foo').
	
	command parseArguments.
	
	self assert: command messageArguments equals: #()
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testShouldActivateHelpWhenHelpFlagPresent [

	| command |
	command := self performCommandWithArguments: #('--help' '--').
	
	command parseCommandOptions.
	
	self assert: command shouldActivateHelp
	
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testShouldNotActivateHelpWhenHelpFlagAbsent [

	| command |
	command := self performCommandWithArguments: #( '--save' '--' 'Foo' 'bar').
	
	command parseCommandOptions.
	
	self deny: command shouldActivateHelp
	
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testShouldNotSaveWhenSaveFlagAbsent [

	| command |
	command := self performCommandWithArguments: #('Foo' 'bar').
	
	command parseCommandOptions.
	
	self deny: command shouldSave
	
]

{ #category : 'tests' }
PerformMessageCommandLineHandlerTest >> testShouldSaveWhenSaveFlagPresent [

	| command |
	command := self performCommandWithArguments: #('--save' '--').
	
	command parseCommandOptions.
	
	self assert: command shouldSave
	
]
