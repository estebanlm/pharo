Extension { #name : 'ClassDescription' }

{ #category : '*CodeExport' }
ClassDescription >> comment [

	self subclassResponsibility
]

{ #category : '*CodeExport' }
ClassDescription >> commentStamp [
	
	self subclassResponsibility
]

{ #category : '*CodeExport' }
ClassDescription >> fileOutLocalMethodsInProtocol: protocol on: aFileStream [
	"File out methods for this protocol."

	aFileStream cr.

	protocol methodSelectors do: [ :selector | self printMethodChunk: selector on: aFileStream ]
]

{ #category : '*CodeExport' }
ClassDescription >> fileOutMethod: selector [
	"Write source code of a single method on a file.  Make up a name for the file."

	| internalStream |
	internalStream := (String new: 1000) writeStream.
	self printMethodChunk: selector on: internalStream.
	CodeExporter writeSourceCodeFrom: internalStream baseName: (self name , '-' , (selector copyReplaceAll: ':' with: '..')) isSt: true
]

{ #category : '*CodeExport' }
ClassDescription >> fileOutOn: aFileStream [
	"File a description of the receiver on aFileStream."

	"we for now file out old style class definitions"

	| exporter |
	exporter := CodeExporter onStream: aFileStream.
	exporter writeClassDefinition: self.
	exporter writeClassCommentOf: self.
	self protocols do: [ :protocol | self fileOutLocalMethodsInProtocol: protocol on: aFileStream ]
]

{ #category : '*CodeExport' }
ClassDescription >> printMethodChunk: selector on: outStream [
	"Copy the source code for the method associated with selector onto the fileStream."

	| exporter |
	exporter := CodeExporter onStream: outStream.
	exporter writeMethod: (self >> selector)
]

{ #category : '*CodeExport' }
ClassDescription >> putCommentOnFile: aFileStream [ 
	"Store the comment about the class onto file, aFileStream."

	| header |
	self comment isEmptyOrNil ifTrue: [ ^ self ].

	aFileStream
		cr;
		nextPut: $!.
	header := String streamContents: [ :strm |
		          strm
			          nextPutAll: self name;
			          nextPutAll: ' commentStamp: '.
		          self commentStamp storeOn: strm.
		          strm
			          nextPutAll: ' prior: ';
			          nextPutAll: '0' ].
	(ChunkWriteStream on: aFileStream)
		nextPut: header.
	self comment ifNotNil: [ :comment |
		(ChunkWriteStream on: aFileStream)
			cr;
			nextPut: comment string ].
	aFileStream cr
]
