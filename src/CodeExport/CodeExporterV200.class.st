Class {
	#name : 'CodeExporterV200',
	#superclass : 'CodeExporterV100',
	#category : 'CodeExport-Base',
	#package : 'CodeExport',
	#tag : 'Base'
}

{ #category : 'writing - low level' }
CodeExporterV200 >> writeClassDefinition: aClassDefinition [

	writeStream cr.
	writeStream bang.
	writeStream nextPut: #BehaviorDefinition.

	writeStream cr.
	writeStream nextPut: aClassDefinition
]

{ #category : 'writing' }
CodeExporterV200 >> writeFileoutVersion [

	writeStream nextPut: '"VERSION:2.0.0"'
]
