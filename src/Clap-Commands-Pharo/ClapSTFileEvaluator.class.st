"
Reads smalltalk code from a file and evaluates it.

Example:

pharo Pharo.image st code.st

*By default files ending in .st are recognized and evaluated*
pharo Pharo.image code.st
"
Class {
	#name : 'ClapSTFileEvaluator',
	#superclass : 'ClapCodeEvaluator',
	#category : 'Clap-Commands-Pharo',
	#package : 'Clap-Commands-Pharo'
}

{ #category : 'command line' }
ClapSTFileEvaluator class >> commandSpecification [
	<commandline>
	| spec |
	spec := (ClapCommandSpec id: #st)
		commandClass: self;
		description: 'The ST command evaluates Pharo code stored in a .st file ';
		addHelp;
		addPositional: #FILE spec: [ :positional |
			positional
				description: 'The Smalltalk file to evaluate (must have .st extension)';
				multiple: true ];
		yourself.
		
	self 
		addSaveFlagTo: spec;
		addKeepAliveOptionTo: spec;
		addRenameOptionTo: spec.
	^ spec
]

{ #category : 'accessing' }
ClapSTFileEvaluator >> allStFiles [

	^ (self positional: #FILE ifAbsent: [ #() ]) 
		select: [ :arg | arg endsWith: '.st' ]
]

{ #category : 'execution' }
ClapSTFileEvaluator >> evaluate [
	
	"polymorphism with ST file evaluator"
	self evaluateStFiles
]

{ #category : 'execution' }
ClapSTFileEvaluator >> evaluateStFile: aFile [

	| codeImporter |

	"first, parse the code"
	aFile readStreamDo: [ :binary | | stream |
		stream := ZnCharacterReadStream on: binary encoding: 'utf8'.
		self
			handleErrorsDuring: [
				self skipShebangFrom: stream.
				codeImporter := CodeImporter fileStream: stream.
				codeImporter logSource: self shouldLogSource.
				codeImporter parseChunks ]
			reference: aFile ].

	"evaluate the declarations in a second step to allow for properly closing the source file stream"
	self
		handleErrorsDuring: [ codeImporter evaluate ]
		reference: aFile
]

{ #category : 'execution' }
ClapSTFileEvaluator >> evaluateStFiles [

	self allStFiles do: [ :fileName |
		self evaluateStFile: (File named: fileName) ]
]

{ #category : 'accessing' }
ClapSTFileEvaluator >> shouldLogSource [

	^ (self hasFlag: #'no-source') not
]

{ #category : 'execution' }
ClapSTFileEvaluator >> skipShebangFrom: readStream [
	"Skip the shebang sequnce #! at the beginning of a file"

	readStream wrappedStream position = 0
		ifFalse: [  ^ self "#! can only be skipped at the beginning" ].

	(readStream wrappedStream next: 2) = '#!'
		ifFalse: [
			readStream wrappedStream position: 0.
			^ self ].

	"here we found the shebang, so skip the first line"
	^ readStream nextLine
]

{ #category : 'validating' }
ClapSTFileEvaluator >> validateParameters [
	self allStFiles ifEmpty: [ ^ self context exitFailure: 'Missing st file as argument' ]
]
