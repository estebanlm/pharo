Extension { #name : 'Form' }

{ #category : '*Deprecated14' }
Form >> magnify: aRectangle by: scale [
	"Answer a Form created as a scaling of the receiver.
	Scale may be a Float, and may be greater or less than 1.0."
	self deprecated: 'This method will be removed in a future version of Pharo, you can use #magnifyBy: if your rectangle is the boundingBox of the receiver instead'.
	^ self magnify: aRectangle by: scale smoothing: 1

]

{ #category : '*Deprecated14' }
Form >> magnify: aRectangle by: scale smoothing: cellSize [
	"Answer a Form created as a scaling of the receiver.
        Scale may be a Float or even a Point, and may be greater or less than 1.0."

	| newForm |
	self deprecated: 'This method will be removed in a future version of Pharo, you can use #magnifyBy:smoothing: if your rectangle is the boundingBox of the receiver instead'.
	newForm := self blankCopyOf: aRectangle scaledBy: scale.
	(WarpBlt toForm: newForm)
		sourceForm: self;
		colorMap: (self colormapIfNeededFor: newForm);
		cellSize: cellSize;
		"installs a new colormap if cellSize > 1"
			combinationRule: 3;
		copyQuad: aRectangle innerCorners toRect: newForm boundingBox.
	^ newForm

	"Dynamic test...
[Sensor anyButtonPressed] whileFalse:
        [(Display magnify: (Sensor cursorPoint extent: 131@81) by: 0.5 smoothing: 2) display]
"
	"Scaling test...
| f cp | f := Form fromDisplay: (Rectangle originFromUser: 100@100).
Display restoreAfter: [Sensor waitNoButton.
[Sensor anyButtonPressed] whileFalse:
        [cp := Sensor cursorPoint.
        (f magnify: f boundingBox by: (cp x asFloat@cp y asFloat)/f extent smoothing: 2) display]]
"
]

{ #category : '*Deprecated14' }
Form >> shrink: aRectangle by: scale [
	| scalePt |
	self deprecated: 'this method will be deleted in a future Pharo version'.
	scalePt := scale asPoint.
	^ self magnify: aRectangle by: (1.0 / scalePt x asFloat) @ (1.0 / scalePt y asFloat)
]
