Extension { #name : 'SmalltalkImage' }

{ #category : '*Deprecated14' }
SmalltalkImage >> isInteractiveGraphic [

	self deprecated: 'Use #isInteractive instead.' transformWith: '`@rcv isInteractiveGraphic' -> '`@rcv isInteractive'.
	^ self isInteractive
]
