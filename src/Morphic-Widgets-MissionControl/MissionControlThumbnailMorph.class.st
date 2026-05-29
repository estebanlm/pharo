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
	window := aSystemWindow.
	originalBounds := aSystemWindow bounds.
	thumbnailForm := aSystemWindow asFormOfSize: thumbExtent.
	self extent: thumbExtent.
	self borderWidth: 2.
	self borderColor: Color veryLightGray.
	self color: Color white.
	self useRoundedCorners.
	self
		on: #mouseEnter
		send: #mouseEnter:event:in:
		to: self;
		on: #mouseLeave
		send: #mouseLeave:event:in:
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
MissionControlThumbnailMorph >> labelHeight [
	^ MissionControlSettings showWindowLabels
		ifTrue: [ StandardFonts defaultFont height + 4 ]
		ifFalse: [ 0 ]
]

{ #category : 'drawing' }
MissionControlThumbnailMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	thumbnailForm ifNotNil: [
		aCanvas translucentImage: thumbnailForm
			at: self position + ((self width - thumbnailForm width) // 2 @ 2) ].
	isHighlighted ifTrue: [
		aCanvas
			frameRectangle: self bounds
			width: 4
			color: (Color blue alpha: 0.6) ]
]

{ #category : 'event handling' }
MissionControlThumbnailMorph >> mouseEnter: evt event: aMorph [
	isHighlighted := true.
	self borderColor: Color blue.
	self changed
]

{ #category : 'event handling' }
MissionControlThumbnailMorph >> mouseLeave: evt event: aMorph [
	isHighlighted := false.
	self borderColor: Color veryLightGray.
	self changed
]

{ #category : 'event handling' }
MissionControlThumbnailMorph >> mouseDown: evt [
	self owner ifNotNil: [ :mc |
		(mc isKindOf: MissionControlMorph) ifTrue: [
			mc deactivateAndShowWindow: self window ] ]
]

{ #category : 'initialization' }
MissionControlThumbnailMorph >> useRoundedCorners [
	self borderStyle: (BorderStyle rounded width: self borderWidth color: self borderColor)
]
