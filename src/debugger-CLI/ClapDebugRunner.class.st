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

{ #category : 'execution' }
ClapDebugRunner >> startLoop [
	"For now, I just print the input to try it"

	| in out input tempRes debugger |
	in := Stdio stdin.

	out := Stdio stdout.

	debugger := CommandLineDebugger new.

	out
		nextPutAll: ' Debug phase started :';
		lf;
		flush.

	out
		nextPutAll: '(debug) > ';
		flush.

	input := in next: 4.

	input = '' ifTrue: [ ^ self ].

	tempRes := debugger executeCommand: input.

	out
		nextPutAll: 'You wrote :';
		nextPutAll: tempRes;
		lf;
		flush
]

{ #category : 'execution' }
ClapDebugRunner >> startLoopTest [
	"Test"

	| line |
	[
    	line := Stdio stdin nextLine.
    	line = 'quit'
	] whileFalse: [
    	Stdio stdout
        nextPutAll: line;
        lf.
	].
]
