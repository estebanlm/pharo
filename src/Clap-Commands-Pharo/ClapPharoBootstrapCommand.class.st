"
Commands used during the bootstrap process.

Do not use it on full Pharo images!
"
Class {
	#name : 'ClapPharoBootstrapCommand',
	#superclass : 'ClapPharoApplication',
	#category : 'Clap-Commands-Pharo',
	#package : 'Clap-Commands-Pharo'
}

{ #category : 'command line' }
ClapPharoBootstrapCommand class >> commandSpecification [ 

	<commandline>
	| command |
	command := (ClapCommandSpec id: #bootstrap)
		  description: 'Provides command useful in bootstrap process';
		  commandClass: self;
		  addHelp;
		  yourself.
		
	self subclasses do: [ :class | 
		command addSubcommand: class commandSpecification ].
	^ command
]
