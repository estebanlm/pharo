Class {
	#name : 'ClapDebugRunner',
	#superclass : 'ClapPharoApplication',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
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

	self startLoop.

	self exitSuccess
]

{ #category : 'private - printing' }
ClapDebugRunner >> informResults: results [

	self outputStreamDo: [ :out |
			(out << ('(debug) > {1} ' format: { results }))
				<< OSPlatform current lineEnding;
				flush ]
]

{ #category : 'execution' }
ClapDebugRunner >> startLoop [

	| input "in" tempRes debugger |
	"in := Stdio stdin."
	debugger := CommandLineDebugger new.

	self inform: 'Debug phase started : '.

	[ debugger isActive ] whileTrue: [
			input := 'print 3+5'.

			tempRes := debugger executeCommand: input asString.

			self informResults: tempRes ]
]
