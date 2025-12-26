Extension { #name : 'MetacelloProjectRegistry' }

{ #category : '*Deprecated14' }
MetacelloProjectRegistry >> baselineProjectSpecs [

	self deprecated: 'Use #projectSpecs instead.' transformWith: '`@rcv baselineProjectSpecs' -> '`@rcv projectSpecs'.
	^ self projectSpecs
]
