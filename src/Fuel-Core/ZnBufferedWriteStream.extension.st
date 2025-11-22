Extension { #name : 'ZnBufferedWriteStream' }

{ #category : '*Fuel-Core' }
ZnBufferedWriteStream >> nextBytesPutAll: aCollection [
	self
		deprecated: 'Please use #nextPutAll: instead'
		transformWith:
		'`@receiver nextBytesPutAll: `@arg' -> '`@receiver nextPutAll: `@arg'.

	^ self nextPutAll: aCollection
]
