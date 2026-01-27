Extension { #name : 'FilesSourcesManager' }

{ #category : '*Deprecated14-Kernel' }
FilesSourcesManager class >> default [

	self deprecated: 'Use `SourcesManager current` instead' transformWith: '`@rcv default' -> 'SourcesManager current'.
	^ SourcesManager current
]

{ #category : '*Deprecated14-Kernel' }
FilesSourcesManager class >> default: anInstance [

	self deprecated: 'Use `SourcesManager current:` instead' transformWith: '`@rcv default: `@arg' -> 'SourcesManager current: `@arg'.
	SourcesManager current: anInstance
]
