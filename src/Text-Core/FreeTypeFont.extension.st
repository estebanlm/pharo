Extension { #name : 'FreeTypeFont' }

{ #category : '*Text-Core' }
FreeTypeFont >> pixelSize [
	^pixelSize ifNil:[pixelSize := super pixelSize rounded]
]
