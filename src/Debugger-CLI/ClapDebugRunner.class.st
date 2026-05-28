Class {
	#name : 'ClapDebugRunner',
	#superclass : 'ClapPharoApplication',
	#instVars : [
		'debugger'
	],
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'command line' }
ClapDebugRunner class >> commandSpecification [

	<commandline>
	| spec |
	spec := (ClapCommandSpec id: #debug)
		        commandClass: self;
		        description: 'A Debug runner to launch debugger from a shell';
		        addHelp;
		        addPositional: #EXPR spec: [ :positional |
				        positional
					        description: 'Debug this code';
					        multiple: true ];
		        yourself.

	self
		addSaveFlagTo: spec;
		addRenameOptionTo: spec.
	^ spec
]

{ #category : 'execution' }
ClapDebugRunner >> execute [

	self prepareImageAndExit.

	self runDebugger.

	self exitSuccess
]

{ #category : 'execution' }
ClapDebugRunner >> expressionToDebug [

	^ self positional: #EXPR 
]

{ #category : 'execution' }
ClapDebugRunner >> runDebugger [
	"Create a debugger and run it"

	| codeString |
	codeString := self expressionToDebug joinUsing: ' '.
	[
		debugger := (CommandLineDebugger forCode: codeString)
			            inStream: self context stdin;
			            outStream: self context stdout ]
		on: Error
		do: [ :e |
				self inform:
					'Cannot create start debugger; Usage: debug <expression>.' , OSPlatform current lineEnding , 'Error details : ' , e asString.
				^ self ].

	debugger parsesAndExecuteCommand: 's'.
	debugger run
]
