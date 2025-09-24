"
An utility class for exporting code to changesets (*.cs) or Smalltalk source (*.st) files
"
Class {
	#name : 'CodeExporter',
	#superclass : 'Object',
	#instVars : [
		'writeStream'
	],
	#category : 'CodeExport-Base',
	#package : 'CodeExport',
	#tag : 'Base'
}

{ #category : 'as yet unclassified' }
CodeExporter class >> onMemory [

	^ self onStream: (String new: 100) writeStream
]

{ #category : 'as yet unclassified' }
CodeExporter class >> onStream: aStream [

	^ self new
		  writeStream: aStream;
		  yourself
]

{ #category : 'file-out' }
CodeExporter class >> writeSourceCodeFrom: aStream baseName: baseName isSt: stOrCsFlag [

	| extension targetFile |
	extension := stOrCsFlag ifTrue: ['st']  ifFalse: ['cs'].
	targetFile := FileLocator imageDirectory / baseName, extension.

	self writeSourceCodeFrom: aStream toFileReference: targetFile
]

{ #category : 'file-out' }
CodeExporter class >> writeSourceCodeFrom: aStream toFileReference: aFileReference [
	"Write the supplied changes to aFileReference"

	aFileReference
		ensureDelete;
		binaryWriteStreamDo: [ :outputStream | (ZnCharacterWriteStream on: outputStream encoding: 'utf8') nextPutAll: aStream contents ].

	UIManager default
		inform:
			(String
				streamContents: [ :s |
					s
						nextPutAll: 'Filed out to: ';
						cr;
						nextPutAll: aFileReference pathString;
						cr;
						cr;
						nextPutAll: 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : 'writing' }
CodeExporter >> writeClassCommentOf: aClass [

	| header |
	aClass comment ifNil: [ ^ self ].

	header := String streamContents: [ :strm |
			          strm
				          nextPutAll: aClass name;
				          nextPutAll: ' commentStamp: '.
			          aClass commentStamp storeOn: strm.
			          strm
				          nextPutAll: ' prior: ';
				          nextPutAll: '0' ]. "Print header"
	writeStream
		cr;
		bang.
	writeStream nextPut: header.

	"Print comment. If empty, we need to put an empty line anyways to avoid breaking the parser"
	writeStream
		cr;
		nextPut: (aClass comment string ifEmpty: [ String cr ]).
	"Print metadata"
	writeStream
		cr;
		nextPut: ''
]

{ #category : 'writing' }
CodeExporter >> writeClassDefinition: aClass [ 

	writeStream cr.
	writeStream nextPut: aClass oldPharoDefinition
]

{ #category : 'writing' }
CodeExporter >> writeClassInitializer: aClass [ 

	writeStream cr.
	writeStream nextPut: aClass name, ' initialize'
]

{ #category : 'writing' }
CodeExporter >> writeMethod: aMethod [

	| preamble methodClass methodSelector |
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.

	preamble := methodClass name , ' methodsFor: ' , (methodClass protocolOfSelector: methodSelector) name asString printString.
	writeStream
		cr; cr; bang;
		nextPut: (String streamContents: [ :strm |
						 strm nextPutAll: preamble.
						 aMethod stamp ifNotEmpty: [ :stamp |
									 strm
										 nextPutAll: ' stamp: ';
										 print: stamp ] ]);

		"Print the source code"
		cr;
		nextPut: aMethod sourceCode;
		"Print the metadata"
		nextPut: ' '
]

{ #category : 'accessing' }
CodeExporter >> writeStream [
	^ writeStream
]

{ #category : 'writing' }
CodeExporter >> writeStream: aWriteStream [ 
	
	writeStream := ChunkWriteStream on: aWriteStream
]
