"
A ChunkFileFormatParserV200Test is a test class for testing the behavior of ChunkFileFormatParserV200
"
Class {
	#name : 'ChunkFileFormatParserV100Test',
	#superclass : 'TestCase',
	#category : 'CodeImport-Tests-Utilities',
	#package : 'CodeImport-Tests',
	#tag : 'Utilities'
}

{ #category : 'tests' }
ChunkFileFormatParserV100Test >> testParseClassDefinition [

	| parser declarations oldDefinition input |
	"Make sure we input the old definition.
	We add a new line and a bang to make it a chunk"
	oldDefinition := ClassDefinitionPrinter oldPharo
		for: self class;
		definitionString.
	input := '
', oldDefinition, '!'.
	
	parser := ChunkFileFormatParserV100 for: input readStream.
	
	declarations := parser parseChunks.
	self assert: declarations size equals: 1.
	self assert: declarations first isDoItDeclaration.
	self assert: declarations first contents equals: oldDefinition.
	self assert: declarations first isClassAdditionChunk
]

{ #category : 'tests' }
ChunkFileFormatParserV100Test >> testParsePackageDefinition [

	| parser declarations |
	parser := ChunkFileFormatParserV100 for: '
SystemOrganization addCategory: #''CodeExport-Tests''!' readStream.
	
	declarations := parser parseChunks.
	self assert: declarations size equals: 1.
	self assert: declarations first isDoItDeclaration.
	self assert: declarations first contents equals: 'SystemOrganization addCategory: #''CodeExport-Tests'''.
	self assert: declarations first isPackageAdditionChunk
]
