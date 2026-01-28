Extension { #name : 'SmalltalkImage' }

{ #category : '*Deprecated14' }
SmalltalkImage >> version [
	"Answer the version of this release."

	self deprecated: 'Use `SystemVersion current` instead'.

	^ SystemVersion current
		  ifNil: [ 'No version set yet' ]
		  ifNotNil: [ :version | version version ]
]
