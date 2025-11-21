"
I represent the chunk file format.  Right now I know how to parse chunks from a readStream, but not how to write them. 
"
Class {
	#name : 'ChunkFileFormatParserV100',
	#superclass : 'Object',
	#instVars : [
		'readStream',
		'parsedDeclarations',
		'classSelector',
		'classTraitSelector',
		'commentStampSelector',
		'methodsForSelector',
		'reorganizeSelector'
	],
	#category : 'CodeImport-Utilities',
	#package : 'CodeImport',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
ChunkFileFormatParserV100 class >> for: aReadStream [
	^self new
		readStream: aReadStream;
		yourself
]

{ #category : 'accessing' }
ChunkFileFormatParserV100 class >> writer [
	
	^ CodeExporterV100
]

{ #category : 'accessing' }
ChunkFileFormatParserV100 >> addDeclaration: aDeclaration [
	parsedDeclarations	 add: aDeclaration
]

{ #category : 'class factory' }
ChunkFileFormatParserV100 >> classCommentChunkClass [
	^ ClassCommentChunk
]

{ #category : 'class factory' }
ChunkFileFormatParserV100 >> classOrganisationChunkClass [
	^ ClassOrganizationChunk
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> classSelector [
	^ classSelector
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> classSelector: anObject [
	classSelector := anObject
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> classTraitSelector [
	^ classTraitSelector
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> classTraitSelector: anObject [
	classTraitSelector := anObject
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> commentStampSelector [
	^ commentStampSelector
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> commentStampSelector: anObject [
	commentStampSelector := anObject
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> defaultClassSelector [
	^ #class
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> defaultClassTraitSelector [
	^ #classTrait
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> defaultCommentStampSelector [
	^ #commentStamp:
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> defaultMethodsForSelector [
	^ #methodsFor:
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> defaultReorganizeSelector [
	^ #reorganize
]

{ #category : 'class factory' }
ChunkFileFormatParserV100 >> doItChunkClass [
	^ DoItChunkV100
]

{ #category : 'initialization' }
ChunkFileFormatParserV100 >> initialize [
	super initialize.
	parsedDeclarations := OrderedCollection new.
	classSelector := self defaultClassSelector.
	classTraitSelector := self defaultClassTraitSelector.
	commentStampSelector := self defaultCommentStampSelector.
	methodsForSelector := self defaultMethodsForSelector.
	reorganizeSelector := self defaultReorganizeSelector
]

{ #category : 'versions' }
ChunkFileFormatParserV100 >> major [

	^ self version first
]

{ #category : 'class factory' }
ChunkFileFormatParserV100 >> methodChunkClass [
	^ MethodChunk
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> methodsForSelector [
	^ methodsForSelector
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> methodsForSelector: anObject [
	methodsForSelector := anObject
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseAndValidateVersion [
	"Parse and validate the version.
	If the file has a version tag as a doIt chunk, validate it.
	"
	
	| firstChunk prefix versionNumber |
	firstChunk := readStream next.
	
	"Cases for old files:
	  - if the first chunk is not a do it, continue
	  - if the first chunk is a doit, it must be a single comment with
	
		VERSION:x[.[y[.z]]]
	
	Where x is the major version, y is the minor version and z is the patch version.
	In this version of the parser, if the format does not hold, we let it pass.
	Otherwise, similar comments may match and break compatibility
	"
	prefix := '"VERSION:'.
	(firstChunk beginsWith: prefix)
		ifFalse: [ 
			readStream reset.
			^ self ].

	versionNumber := ((firstChunk allButFirst: prefix size)
		"skip the last double quote of the comment"
		allButLast
		splitOn: $.)
			collect: [ :e | | stream version |
				"If the version is not an integer, ignore and continue to parse an old file"
				stream := e readStream.
				version := (NumberParser on: stream)
					failBlock: [ 
						readStream reset.
						^ self ];
					nextIntegerBase: 10.
				stream atEnd ifFalse: [ 
					readStream reset.
					^ self ].
				version ] as: Array.
	

	
	(#(#(1) #(1 0) #(1 0 0)) includes: versionNumber)
		ifFalse: [ CodeImportError signal: 'Parser VERSION ', self versionString, ' cannot read file VERSION ', ($. join: versionNumber) ]
]

{ #category : 'as yet unclassified' }
ChunkFileFormatParserV100 >> parseChunkWithMetadata: nextChunk [

	| substrings |
	substrings := OCParser parseLiterals: nextChunk.
	(substrings includes: self methodsForSelector asString) ifTrue: [ ^ self parseMethodDeclarations: substrings ].
	(substrings includes: self commentStampSelector asString) ifTrue: [ ^ self parseCommentDeclaration: substrings ].
	^ (substrings includes: self reorganizeSelector asString) ifTrue: [ ^ self parseClassOrganization: substrings ]
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseChunks [

	self parseAndValidateVersion.
	[ readStream atEnd ] whileFalse: [ self parseNextDeclaration ].
	^ parsedDeclarations
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseClassOrganization: classOrganizationPreamble [
	"The comment preable is an array with the following structure:
	If instance side method:
	#(#CodeImportTestCaseTestClass #reorganize)

	if class side:

	#(#CodeImportTestCaseTestClass #class #reorganize)
	"

	| behaviorName isMeta organizationContents metadata |
	behaviorName := classOrganizationPreamble first.
	isMeta := classOrganizationPreamble second ~= self reorganizeSelector.
	organizationContents := readStream next.
	metadata := readStream next.
	self addDeclaration:
		((self classOrganisationChunkClass contents: organizationContents behaviorName: behaviorName isMeta: isMeta)
			 metadata: metadata;
			 yourself)
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseCommentDeclaration: commentPreamble [
	"The comment preable is an array with the following structure:
	If instance side method:
	#(#CodeImportTestCaseTestClass #commentStamp: '<historical>' #prior: 0)

	if class side:

	#(#CodeImportTestCaseTestClass #class #commentStamp: '<historical>' #prior: 0)
	allButFirst:
	"

	| behaviorName isMeta stamp commentContents metadata |
	behaviorName := commentPreamble first asSymbol.
	isMeta := commentPreamble second ~= self commentStampSelector.
	stamp := isMeta
		         ifTrue: [ commentPreamble at: 4 ]
		         ifFalse: [ commentPreamble at: 3 ].

	commentContents := readStream next.
	metadata := ' '.
	self addDeclaration: ((self classCommentChunkClass
			  contents: commentContents
			  behaviorName: behaviorName
			  isMeta: isMeta
			  stamp: stamp)
			 metadata: metadata;
			 yourself)
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseMethodDeclarations: methodsPreamble [

	| behaviorName isMeta protocol stamp methodSource methodMetadata |
	"The method preable is an array with the following structure:
	If instance side method:

	#(#CodeImportTestCaseTestClass #methodsFor: 'some protocol' #stamp: 'GuillermoPolito 5/2/2012 13:35')

	if class side:

	#(#CodeImportTestCaseTestClass #class #methodsFor: 'some protocol' #stamp: 'GuillermoPolito 5/2/2012 13:35')

	Sometimes there is no timestamp: 

	#(#CodeImportTestCaseTestClass #methodsFor: 'some protocol')

	"
	behaviorName := methodsPreamble first.
	isMeta := methodsPreamble second = self classSelector or: [ methodsPreamble second = self classTraitSelector ].
	protocol := isMeta
		            ifTrue: [ methodsPreamble at: 4 ]
		            ifFalse: [ methodsPreamble at: 3 ].
	stamp := ''.
	methodsPreamble size > 4 ifTrue: [
			stamp := isMeta
				         ifTrue: [ methodsPreamble at: 6 ]
				         ifFalse: [ methodsPreamble at: 5 ] ].

	methodSource := readStream next.
	methodMetadata := readStream next.
	self addDeclaration: ((self methodChunkClass
			  contents: methodSource
			  behaviorName: behaviorName asSymbol
			  isMeta: isMeta
			  protocol: protocol
			  stamp: stamp)
			 metadata: methodMetadata;
			 yourself)
]

{ #category : 'parsing' }
ChunkFileFormatParserV100 >> parseNextDeclaration [

	| isMetadata nextChunk |
	readStream skipSeparators.
	isMetadata := readStream isNextChunkMetaData.
	nextChunk := readStream next.
	isMetadata
		ifFalse: [ self addDeclaration: (self doItChunkClass contents: nextChunk) ]
		ifTrue: [ self parseChunkWithMetadata: nextChunk ]
]

{ #category : 'accessing' }
ChunkFileFormatParserV100 >> readStream: aReadStream [
	readStream := ChunkReadStream on: aReadStream
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> reorganizeSelector [
	^ reorganizeSelector
]

{ #category : 'custom points' }
ChunkFileFormatParserV100 >> reorganizeSelector: anObject [
	reorganizeSelector := anObject
]

{ #category : 'versions' }
ChunkFileFormatParserV100 >> version [
	
	^ #( 1 0 0 )
]

{ #category : 'versions' }
ChunkFileFormatParserV100 >> versionString [

	^ $. join: self version
]
