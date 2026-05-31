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
MissionControlMorph class >> toggleInWorld: world [

	| currentControlMission |
	
	currentControlMission := world submorphs detect: [ :m | m isKindOf: self ] ifNone: [ nil ].

	currentControlMission ifNil: [ self new activateInWorld: world ]
]

{ #category : 'activation' }
MissionControlMorph >> activateInWorld: world [

	| nonCollapsed collapsed |

	nonCollapsed := world systemWindows reject: #isCollapsed.
	collapsed := world systemWindows select: #isCollapsed.

	self bounds: world bounds.
	spacesBar := MissionControlSpacesBar new initializeForWorld: world collapsedWindows: collapsed.
	
	self addMorph: spacesBar.
	world addMorphFront: self.
	self createThumbnailsFor: nonCollapsed.
	world activeHand newKeyboardFocus: self.
	isActive := true
]

{ #category : 'private' }
MissionControlMorph >> createThumbnailsFor: windows [

	| padding spacing available size cols rows cellW cellH labelHeight |

	windows ifEmpty: [ ^ self ].
	
	thumbnails := OrderedCollection new.
	
	size := windows size.
	
	padding := MissionControlSettings thumbnailPadding.
	available := self bounds insetBy: padding.
	available := available withTop: (available top + spacesBar height + padding).
	labelHeight := self labelHeight.
	cols := size sqrt ceiling.
	rows := (size / cols) ceiling.
	spacing := self spacing.
	
	cellW := (available width - (spacing * (cols - 1))) / cols.
	cellH := (available height - (labelHeight * rows) - (spacing * (rows - 1))) / rows.
	
	self createThumbnailsFor: windows cols: cols availableSpace: available cellW: cellW cellH: cellH labelHeight: labelHeight
]

{ #category : 'private' }
MissionControlMorph >> createThumbnailsFor: windows cols: cols availableSpace: available cellW: cellW cellH: cellH labelHeight: labelHeight [

	| currentThumbExtent spacing scale|
	
	spacing := self spacing.

	windows withIndexDo: [ :w :i | | col row thumbnail cellLeft cellTop lm |
		col := (i - 1) \\ cols.
		row := (i - 1) // cols.
		scale := (cellW / w extent x) min: (cellH / w extent y).
		scale := scale min: 1.0.
		currentThumbExtent := (w extent * scale) rounded.
		thumbnail := MissionControlThumbnailMorph new
			initializeForWindow: w extent: currentThumbExtent.
		self addMorph: thumbnail.
		thumbnails add: thumbnail.
		cellLeft := available left + (col * (cellW + spacing)).
		cellTop := available top + (row * (cellH + labelHeight + spacing)).
		thumbnail
			position: (cellLeft + ((cellW - currentThumbExtent x) // 2))
				@ (cellTop + ((cellH - currentThumbExtent y) // 2)).
		MissionControlSettings showWindowLabels ifTrue: [
			lm := thumbnail buildLabel.
			lm ifNotNil: [
				lm position: (cellLeft + ((cellW - lm width) // 2))
					@ (thumbnail position y + currentThumbExtent y + 2).
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

{ #category : 'private' }
MissionControlMorph >> labelHeight [

	^ MissionControlSettings showWindowLabels
		  ifTrue: [ StandardFonts defaultFont height + 4 ]
		  ifFalse: [ 0 ]
]

{ #category : 'wiw support' }
MissionControlMorph >> morphicLayerNumber [
	^ 5
]

{ #category : 'accessing' }
MissionControlMorph >> spacesBar [
	^ spacesBar
]

{ #category : 'private' }
MissionControlMorph >> spacing [

	"this defines the space between tabs"
	^ 8
]

{ #category : 'accessing' }
MissionControlMorph >> thumbnails [
	^ thumbnails
]

{ #category : 'accessing' }
MissionControlMorph >> wantsToBeTopmost [
	^ true
]
