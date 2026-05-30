Class {
	#name : 'MissionControlSpacesBar',
	#superclass : 'BorderedMorph',
	#instVars : [
		'desktopThumbnail',
		'spaceThumbnails'
	],
	#category : 'Morphic-Widgets-MissionControl',
	#package : 'Morphic-Widgets-MissionControl'
}

{ #category : 'private' }
MissionControlSpacesBar >> buildDesktopThumbnailFor: aWorld extent: thumbExtent [
	| image |
	image := ImageMorph new
		form: (aWorld asFormOfSize: thumbExtent);
		yourself.
	image setProperty: #isDesktopThumbnail toValue: true.
	^ image
]

{ #category : 'private' }
MissionControlSpacesBar >> buildSpaceThumbnailFor: aWindow extent: thumbExtent [
	| image thumb |
	image := aWindow taskThumbnailOfSize: thumbExtent.
	image setProperty: #window toValue: aWindow.
	^ image
]

{ #category : 'accessing' }
MissionControlSpacesBar >> desktopThumbnail [
	^ desktopThumbnail
]

{ #category : 'drawing' }
MissionControlSpacesBar >> drawOn: aCanvas [
	aCanvas
		fillRectangle: self bounds
		fillStyle: (SolidFillStyle color: (Color black alpha: 0.3)).
	super drawOn: aCanvas
]

{ #category : 'event handling' }
MissionControlSpacesBar >> handlesMouseDown: evt [
	^ true
]

{ #category : 'initialization' }
MissionControlSpacesBar >> initializeForWorld: aWorld collapsedWindows: collapsedWindows [
	| barHeight thumbExtent |
	barHeight := 80.
	thumbExtent := 120 @ 60.
	self
		extent: (aWorld width @ barHeight);
		position: aWorld position;
		color: (Color black alpha: 0.3);
		borderWidth: 0.
	self changeTableLayout;
		listDirection: #leftToRight;
		cellInset: 8;
		layoutInset: 8;
		hResizing: #spaceFill;
		vResizing: #rigid;
		wrapCentering: #center;
		cellPositioning: #center.
	desktopThumbnail := self buildDesktopThumbnailFor: aWorld extent: thumbExtent.
	self addMorph: desktopThumbnail.
	spaceThumbnails := OrderedCollection new.
	collapsedWindows do: [ :w |
		| thumb |
		thumb := self buildSpaceThumbnailFor: w extent: thumbExtent.
		self addMorph: thumb.
		spaceThumbnails add: thumb ]
]

{ #category : 'event handling' }
MissionControlSpacesBar >> mouseDown: evt [
	| clicked |
	clicked := self submorphs
		detect: [ :m | m bounds containsPoint: evt position ]
		ifNone: [ nil ].
	clicked ifNil: [ ^ self ].
	(clicked hasProperty: #isDesktopThumbnail) ifTrue: [
		self owner ifNotNil: [ :mc |
			(mc isKindOf: MissionControlMorph) ifTrue: [ mc deactivate ] ].
		^ self ].
	(clicked hasProperty: #window) ifTrue: [
		| w |
		w := clicked valueOfProperty: #window.
		self owner ifNotNil: [ :mc |
			(mc isKindOf: MissionControlMorph) ifTrue: [ mc deactivateAndShowWindow: w ] ] ]
]

{ #category : 'accessing' }
MissionControlSpacesBar >> spaceThumbnails [
	^ spaceThumbnails
]
