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
	header := String streamContents: [ :strm |
			          strm
				          nextPutAll: aClass name;
				          nextPutAll: ' commentStamp: '.
			          aClass commentStamp storeOn: strm.
			          strm
				          nextPutAll: ' prior: ';
				          nextPutAll: '0' ].
	writeStream nextPut: header.
	aClass comment ifNotNil: [ :comment |
			writeStream
				cr;
				nextPut: comment string ].
	writeStream cr
]

{ #category : 'writing' }
CodeExporter >> writeClassDefinition: aClass [ 
	
	writeStream nextPut: aClass oldDefinition
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
		cr;
		nextPut: '';
		nextPut: (String streamContents: [ :strm |
						 strm nextPutAll: preamble.
						 aMethod stamp ifNotEmpty: [ :stamp |
									 strm
										 nextPutAll: ' stamp: ';
										 print: stamp ] ]);
		cr;
		"Print the source code"
		nextPut: aMethod sourceCode;
		nextPut: ' ';
		cr
]

{ #category : 'accessing' }
CodeExporter >> writeStream [
	^ writeStream
]

{ #category : 'writing' }
CodeExporter >> writeStream: aWriteStream [ 
	
	writeStream := ChunkWriteStream on: aWriteStream
]
