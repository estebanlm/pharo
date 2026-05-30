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

{ #category : 'accessing' }
MissionControlThumbnailMorph >> window [
	^ window
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
	self borderWidth: 0.
	self color: Color white.
	self useRoundedCorners.
	self
		on: #mouseEnter
		send: #mouseEnter:event:
		to: self;
		on: #mouseLeave
		send: #mouseLeave:event:
		to: self
]

{ #category : 'initialization' }
MissionControlThumbnailMorph >> initializeForWindow: aSystemWindow [
	self initializeForWindow: aSystemWindow extent: (aSystemWindow extent * 0.25) rounded
]

{ #category : 'accessing' }
MissionControlThumbnailMorph >> labelMorph [
	^ labelMorph
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

{ #category : 'private' }
MissionControlThumbnailMorph >> safeThumbnailOf: aWindow size: extent [
	^ [ aWindow asFormOfSize: extent ]
		on: Error
		do: [ Form extent: extent depth: 32 ]
]

{ #category : 'private' }
MissionControlThumbnailMorph >> labelHeight [
	^ MissionControlSettings showWindowLabels
		ifTrue: [ StandardFonts defaultFont height + 4 ]
		ifFalse: [ 0 ]
]

{ #category : 'drawing' }
MissionControlThumbnailMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	isHighlighted
		ifTrue: [
			aCanvas
				frameRectangle: self bounds
				width: 4
				color: (Color blue alpha: 0.6) ]
		ifFalse: [
			aCanvas
				frameRectangle: self bounds
				width: 2
				color: Color veryLightGray ].
	thumbnailForm ifNotNil: [
		aCanvas translucentImage: thumbnailForm
			at: self position + ((self width - thumbnailForm width) // 2 @ 2) ]
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

{ #category : 'initialization' }
MissionControlThumbnailMorph >> useRoundedCorners [
	super useRoundedCorners
]
