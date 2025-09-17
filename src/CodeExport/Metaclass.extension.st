Extension { #name : 'Metaclass' }

{ #category : '*CodeExport' }
Metaclass >> fileOutInitializerOn: aStream [
	(self includesSelector: #initialize) ifTrue:
		[aStream cr.
		(ChunkWriteStream on: aStream) nextPut: self soleInstance name , ' initialize']
]

{ #category : '*CodeExport' }
Metaclass >> fileOutOn: aFileStream [

	^ self fileOutOn: aFileStream initializing: true
]

{ #category : '*CodeExport' }
Metaclass >> fileOutOn: aFileStream initializing: aBool [

	super fileOutOn: aFileStream.
	(aBool and: [ self includesSelector: #initialize ]) ifFalse: [ ^ self ].

	(ChunkWriteStream on: aFileStream)
		cr;
		cr;
		nextPut: thisClass name , ' initialize';
		cr
]

{ #category : '*CodeExport' }
Metaclass >> nonTrivial [
	"Answer whether the receiver has any methods or instance variables."

	^ self instVarNames notEmpty or: [self hasMethods or: [self hasTraitComposition]]
]
