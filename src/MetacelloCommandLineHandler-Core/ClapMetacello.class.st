"
I allow to load code with Metacello from command line.
"
Class {
	#name : 'ClapMetacello',
	#superclass : 'ClapPharoApplication',
	#category : 'MetacelloCommandLineHandler-Core',
	#package : 'MetacelloCommandLineHandler-Core'
}

{ #category : 'command line' }
ClapMetacello class >> commandSpecification [
	<commandline>
	
	| spec |
	spec := (ClapCommandSpec id: #metacello)
		description: 'Load and install code using Metacello';
		commandClass: self;
		addHelp;
		add: ClapCommandSpec forHelp;
		addPositional: #repository description: 'URL of the repository to load code from';
		addPositional: #project description: 'Name of the project to load (i.e. the name coming after BaselineOf)';
		addFlagWithPositional: #groups description: 'Names of groups to load, comma-separated';
		yourself.
		
	self 
		addSaveFlagTo: spec;
		addKeepAliveOptionTo: spec;
		addNoQuitOptionTo: spec;
		addRenameOptionTo: spec.
	^ spec
]

{ #category : 'execution' }
ClapMetacello >> execute [

	| metacello |
	super execute.
	metacello := Metacello new
		             baseline: self projectName;
		             repository: self repositoryUrl;
		             yourself.
	self groups 
		ifEmpty: [ metacello load ] 
		ifNotEmpty: [ metacello load: self groups ].
		
	self saveSessionIfAsked
]

{ #category : 'accessing' }
ClapMetacello >> groups [

	^ self positional: #groups 
		ifPresent: [ :groups | $, split: groups ] 
		ifAbsent: [ #(  ) ]
]

{ #category : 'execution' }
ClapMetacello >> metacelloScript [

	| metacello |
	metacello := Metacello new.
	metacello baseline: self projectName.
	metacello repository: self repositoryUrl.
	self groups
		ifEmpty: [ metacello load ]
		ifNotEmpty: [ metacello load: self groups ]
]

{ #category : 'accessing' }
ClapMetacello >> projectName [
	^ self positional: #project
]

{ #category : 'accessing' }
ClapMetacello >> repositoryUrl [
	^ self positional: #repository
]
