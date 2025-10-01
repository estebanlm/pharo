Extension { #name : 'CompiledMethod' }

{ #category : '*System-Sources' }
CompiledMethod >> putSource: source withFooter: footer priorSourcePointer: priorSourcePointer [
	"Store the source code for the receiver on an external file."

	SourceFiles
		writeSource: source
		ofMethod: self
		metadata: footer
		priorSourcePointer: priorSourcePointer
		onSuccess: [ :newSourcePointer |
			"Update with new source pointer"
			self sourcePointer: newSourcePointer ]
		onFail: [
			"if we can not store the source pointer, we put back the property"
			self propertyAt: #source put: source ]
]

{ #category : '*System-Sources' }
CompiledMethod >> putSource: source withFooter: footer timestamp: aTimestamp priorSourcePointer: priorSourcePointer [
	"Store the source code for the receiver on an external file."

	SourceFiles
		writeSource: source
		ofMethod: self
		metadata: footer
		timestamp: aTimestamp
		priorSourcePointer: priorSourcePointer
		onSuccess: [ :newSourcePointer | "Update with new source pointer" self sourcePointer: newSourcePointer ]
		onFail: [ "if we can not store the source pointer, we put back the property" self propertyAt: #source put: source ]
]
