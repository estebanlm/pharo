Extension { #name : 'MetacelloVersionSpec' }

{ #category : '*Deprecated14' }
MetacelloVersionSpec >> spec [

	self deprecated: 'MetacelloVersion got merged in his spec MetacelloVersionSpec.' transformWith: '`@rcv spec' -> '`@rcv'.
	^ self
]
