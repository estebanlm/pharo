Class {
	#name : 'MissionControlThumbnailMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'window',
		'thumbnailForm',
		'labelMorph',
		'isHighlighted',
		'originalBounds'
	],
	#category : 'Morphic-Widgets-MissionControl',
	#package : 'Morphic-Widgets-MissionControl'
}

{ #category : 'drawing' }
MissionControlThumbnailMorph >> borderColor [

	^ isHighlighted ifTrue: [ Color blue ] ifFalse: [ Color veryLightGray ]

]

{ #category : 'private' }
MissionControlThumbnailMorph >> buildLabel [
	| title |
	labelMorph ifNotNil: [ ^ labelMorph ].
	MissionControlSettings showWindowLabels ifFalse: [ ^ nil ].
	title := window labelString.
	title size > 30 ifTrue: [ title := (title first: 30) , '...' ].
	labelMorph := StringMorph contents: title font: StandardFonts defaultFont.
	labelMorph color: Color white.
	^ labelMorph
]

{ #category : 'drawing' }
MissionControlThumbnailMorph >> drawOn: aCanvas [

	super drawOn: aCanvas.
	thumbnailForm ifNotNil: [
		aCanvas translucentImage: thumbnailForm at: self position + (self width - thumbnailForm width // 2 @ 2)
	].

	aCanvas frameRectangle: self bounds width: 2 color: self borderColor.
]

{ #category : 'initialization' }
MissionControlThumbnailMorph >> initializeForWindow: aSystemWindow [
	self initializeForWindow: aSystemWindow extent: (aSystemWindow extent * 0.25) rounded
]

{ #category : 'initialization' }
MissionControlThumbnailMorph >> initializeForWindow: aSystemWindow extent: thumbExtent [
	| safeExtent |
	window := aSystemWindow.
	originalBounds := aSystemWindow bounds.
	safeExtent := thumbExtent max: 10 @ 10.
	thumbnailForm := self safeThumbnailOf: aSystemWindow size: safeExtent.
	isHighlighted := false.
	self extent: safeExtent.
	self borderColor: Color veryLightGray.
	self color: Color white.
	self borderWidth: 2.
	self useRoundedCorners.
	self on: #mouseEnter send: #mouseEnter:event: to: self;
		on: #mouseLeave send: #mouseLeave:event: to: self
]

{ #category : 'private' }
MissionControlThumbnailMorph >> labelHeight [
	^ MissionControlSettings showWindowLabels
		ifTrue: [ StandardFonts defaultFont height + 4 ]
		ifFalse: [ 0 ]
]

{ #category : 'accessing' }
MissionControlThumbnailMorph >> labelMorph [
	^ labelMorph
]

{ #category : 'event handling' }
MissionControlThumbnailMorph >> mouseEnter: evt event: aMorph [
	isHighlighted := true.
	self changed
]

{ #category : 'event handling' }
MissionControlThumbnailMorph >> mouseLeave: evt event: aMorph [
	isHighlighted := false.
	self changed
]

{ #category : 'private' }
MissionControlThumbnailMorph >> safeThumbnailOf: aWindow size: extent [
	^ [ aWindow asFormOfSize: extent ]
		on: Error
		do: [ Form extent: extent depth: 32 ]
]

{ #category : 'accessing' }
MissionControlThumbnailMorph >> window [
	^ window
]
