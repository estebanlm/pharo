Class {
	#name : 'MissionControlMorph',
	#superclass : 'Morph',
	#instVars : [
		'thumbnails',
		'spacesBar',
		'isActive'
	],
	#category : 'Morphic-Widgets-MissionControl',
	#package : 'Morphic-Widgets-MissionControl'
}

{ #category : 'activation' }
MissionControlMorph class >> toggleInWorld: aWorld [
	| current |
	current := aWorld submorphs
		detect: [ :m | m isKindOf: self ]
		ifNone: [ nil ].
	current
		ifNil: [ self new activateInWorld: aWorld ]
		ifNotNil: [ current deactivate ]
]

{ #category : 'activation' }
MissionControlMorph >> activateInWorld: aWorld [
	| nonCollapsed collapsed |
	nonCollapsed := (aWorld systemWindows select: [ :w | w isCollapsed not ]).
	collapsed := (aWorld systemWindows select: [ :w | w isCollapsed ]).
	self bounds: aWorld bounds.
	spacesBar := MissionControlSpacesBar new
		initializeForWorld: aWorld
		collapsedWindows: collapsed.
	self addMorph: spacesBar.
	aWorld addMorphFront: self.
	self createThumbnailsFor: nonCollapsed.
	aWorld activeHand newKeyboardFocus: self.
	isActive := true
]

{ #category : 'private' }
MissionControlMorph >> createThumbnailsFor: windows [
	| padding spacing available n cols rows cellW cellH labelHeight scale thumbExtent |
	thumbnails := OrderedCollection new.
	n := windows size.
	n = 0 ifTrue: [ ^ self ].
	padding := MissionControlSettings thumbnailPadding.
	available := self bounds insetBy: padding.
	available := available withTop: (available top + spacesBar height + padding).
	labelHeight := MissionControlSettings showWindowLabels
		ifTrue: [ StandardFonts defaultFont height + 4 ]
		ifFalse: [ 0 ].
	cols := n sqrt ceiling.
	rows := (n / cols) ceiling.
	spacing := 8.
	cellW := (available width - (spacing * (cols - 1))) / cols.
	cellH := (available height - (labelHeight * rows) - (spacing * (rows - 1))) / rows.
	windows withIndexDo: [ :w :i |
		| col row thumbnail cellLeft cellTop label lm |
		col := (i - 1) \\ cols.
		row := (i - 1) // cols.
		scale := (cellW / w extent x) min: (cellH / w extent y).
		scale := scale min: 1.0.
		thumbExtent := (w extent * scale) rounded.
		thumbnail := MissionControlThumbnailMorph new
			initializeForWindow: w extent: thumbExtent.
		self addMorph: thumbnail.
		thumbnails add: thumbnail.
		cellLeft := available left + (col * (cellW + spacing)).
		cellTop := available top + (row * (cellH + labelHeight + spacing)).
		thumbnail
			position: (cellLeft + ((cellW - thumbExtent x) // 2))
				@ (cellTop + ((cellH - thumbExtent y) // 2)).
		MissionControlSettings showWindowLabels ifTrue: [
			lm := thumbnail buildLabel.
			lm ifNotNil: [
				lm position: (cellLeft + ((cellW - lm width) // 2))
					@ (thumbnail position y + thumbExtent y + 2).
				self addMorph: lm ] ]
	]
]

{ #category : 'activation' }
MissionControlMorph >> deactivate [
	| w |
	w := self world.
	self delete.
	isActive := false.
	w ifNotNil: [ w activeHand newKeyboardFocus: nil ]
]

{ #category : 'activation' }
MissionControlMorph >> deactivateAndShowWindow: aSystemWindow [
	| w |
	w := self world.
	self delete.
	isActive := false.
	w ifNotNil: [ w activeHand newKeyboardFocus: nil ].
	aSystemWindow
		unexpandedFrame: aSystemWindow fullFrame;
		activate;
		fullscreen
]

{ #category : 'drawing' }
MissionControlMorph >> drawOn: aCanvas [
	aCanvas
		fillRectangle: self bounds
		fillStyle: (SolidFillStyle color: (Color black alpha: MissionControlSettings overlayOpacity))
]

{ #category : 'event handling' }
MissionControlMorph >> handleMouseDown: evt [
	| clicked |
	evt wasHandled ifTrue: [ ^ self ].
	(spacesBar bounds containsPoint: evt position) ifTrue: [ ^ self ].
	clicked := thumbnails detect: [ :t |
		t bounds containsPoint: evt position ] ifNone: [ nil ].
	clicked ifNotNil: [ ^ self deactivateAndShowWindow: clicked window ].
	self deactivate
]

{ #category : 'event handling' }
MissionControlMorph >> handlesKeyDown: evt [
	^ true
]

{ #category : 'event handling' }
MissionControlMorph >> handlesKeyboard: evt [
	^ true
]

{ #category : 'event handling' }
MissionControlMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : 'accessing' }
MissionControlMorph >> isActive [
	^ isActive
]

{ #category : 'event handling' }
MissionControlMorph >> keyDown: evt [
	evt keyCharacter = Character escape ifTrue: [ ^ self deactivate ]
]

{ #category : 'wiw support' }
MissionControlMorph >> morphicLayerNumber [
	^ 5
]

{ #category : 'accessing' }
MissionControlMorph >> spacesBar [
	^ spacesBar
]

{ #category : 'accessing' }
MissionControlMorph >> thumbnails [
	^ thumbnails
]

{ #category : 'accessing' }
MissionControlMorph >> wantsToBeTopmost [
	^ true
]
