Extension { #name : 'CompiledMethod' }

{ #category : '*System-Sources' }
CompiledMethod >> getPreambleFrom: aFileStream at: position [
	^ SourceFileArray default getPreambleFrom: aFileStream at: position
]

{ #category : '*System-Sources' }
CompiledMethod >> putSource: source withFooter: footer protocol: protocol timestamp: aTimestamp priorSourcePointer: priorSourcePointer [
	"Store the source code for the receiver on an external file."

	SourcesManager current
		writeSource: source
		of: self
		withFooter: footer
		protocol: protocol
		timestamp: aTimestamp
		priorSourcePointer: priorSourcePointer
]
