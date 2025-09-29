"
I hook Clap into the existing command-line handlers system.
"
Class {
	#name : 'ClapCommandLineHandler',
	#superclass : 'CommandLineHandler',
	#category : 'Clap-CommandLine',
	#package : 'Clap-CommandLine'
}

{ #category : 'class initialization' }
ClapCommandLineHandler class >> initialize [
	
	self registerAsCommandLinehandler
]

{ #category : 'registration' }
ClapCommandLineHandler class >> registerAsCommandLinehandler [
	SessionManager default in: [ :manager |
		manager
			register: (NamedSessionHandler forClassNamed: self name id: #commandLineHandler)
			inCategory: manager systemCategory ]
]

{ #category : 'system startup' }
ClapCommandLineHandler class >> startUp: isImageStarting [
	"only handle when launching a new image"
	isImageStarting ifFalse: [ ^ self ].

	Smalltalk session
		addDeferredStartupAction: [ self new activate ]
]

{ #category : 'activation' }
ClapCommandLineHandler >> activate [
	
	ClapContext executeWithPragmaCommandsAndArguments: self arguments
]
