Extension { #name : 'Metaclass' }

{ #category : '*CodeExport' }
Metaclass >> fileOutInitializerOn: aStream [

	(self includesSelector: #initialize) ifTrue: [
			| exporter |
			exporter := CodeExporter onStream: aStream.
			exporter writeClassInitializer: thisClass ]
]

{ #category : '*CodeExport' }
Metaclass >> fileOutOn: aFileStream [

	^ self fileOutOn: aFileStream initializing: true
]

{ #category : '*CodeExport' }
Metaclass >> fileOutOn: aFileStream initializing: aBool [

	super fileOutOn: aFileStream.
	aBool
		ifTrue: [ self fileOutInitializerOn: aFileStream ]

	
	
]

{ #category : '*CodeExport' }
Metaclass >> nonTrivial [
	"Answer whether the receiver has any methods or instance variables."

	^ self instVarNames notEmpty or: [self hasMethods or: [self hasTraitComposition]]
]
