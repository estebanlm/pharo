"
A themed task list/switcher to select the topmost window. Opens on Alt+Tab (Option+Tab on macOS).
Hold the modifier key to keep the switcher open; press Tab to cycle forward, Shift+Tab to cycle backward.
Styled similarly to the macOS app switcher (Cmd+Tab) with a dark rounded panel, horizontal thumbnails,
and a white selection highlight.
"
Class {
	#name : 'TaskListMorph',
	#superclass : 'Morph',
	#instVars : [
		'tasks'
	],
	#classVars : [
		'KeepOpen'
	],
	#category : 'Morphic-Widgets-Taskbar',
	#package : 'Morphic-Widgets-Taskbar'
}

{ #category : 'testing' }
TaskListMorph class >> isNavigationEvent: aKeyboardEvent [

	^ aKeyboardEvent asKeyCombination = Character tab alt or: [ aKeyboardEvent asKeyCombination = Character tab alt shift ]
]

{ #category : 'settings' }
TaskListMorph class >> keepOpen [
	^ KeepOpen ifNil: [KeepOpen := false]
]

{ #category : 'settings' }
TaskListMorph class >> keepOpen: aBoolean [
	KeepOpen := aBoolean
]

{ #category : 'settings' }
TaskListMorph class >> taskListSettingOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #keepTaskListOpen)
		label: 'Keep task list open';
		description: 'Whether the tasklist is closed (and the selected window activated) when the command key is released';
		default: false;
		parent: #morphic;
		selector: #keepOpen;
		target: self
]

{ #category : 'private' }
TaskListMorph >> activeTask [
	"Answer the active task"

	^self tasks detect: [:t | t isActive] ifNone: []
]

{ #category : 'private' }
TaskListMorph >> addMorphs [
	"Sub-morphs are populated by updateTaskButtons."
	self layoutChanged
]

{ #category : 'private' }
TaskListMorph >> baseBorderColor [

	^ Color veryLightGray
]

{ #category : 'private' }
TaskListMorph >> defaultPreviewExtent [
	"Answer the default extent for each individual task thumbnail."

	^(140@100) scaledByDisplayScaleFactor
]

{ #category : 'open/close' }
TaskListMorph >> doOpenInWorld: aWorld [
	"Update the layout after opening."

	aWorld addMorphCentered: self
]

{ #category : 'running' }
TaskListMorph >> done [
	"Close the tasklist and make the active task current."

	self delete.
	self activeTask ifNotNil: [ :t | t activate ]
]

{ #category : 'private' }
TaskListMorph >> effectivePreviewExtent [
	"Answer the preview extent scaled down proportionally if there are too many
	tasks to fit within maxWidth, otherwise the default.
	Accounts for the per-container overhead (borders + layout insets) of 16px."

	| maxWidth n overhead scale |
	maxWidth := self maxWidth.
	n := self tasks size.
	n <= 1 ifTrue: [ ^ self defaultPreviewExtent ].
	"Each container adds ~16px overhead: max(borderWidth*2) + 2*containerLayoutInset"
	overhead := 16.
	scale := (maxWidth - (self layoutInset * 2) - (n * overhead) - ((n - 1) * self cellInset))
		/ (n * self defaultPreviewExtent x).
	scale := (scale min: 1.0) max: 0.2.
	^ (self defaultPreviewExtent * scale) asIntegerPoint
]

{ #category : 'event handling' }
TaskListMorph >> handleEvent: anEvent [
	"Handle Alt+Tab navigation directly to avoid wasHandled flag issues.
	When a SystemWindow delegates navigationKey: to the world, the event
	arrives here already marked as handled, which would skip handleKeyDown:.
	
	Only process keyDown events — keyUp also reaches here via
	sendFocusEvent:to:clear: and would produce a duplicate step."

	(anEvent isKeyboard and: [anEvent isKeyDown and: [self class isNavigationEvent: anEvent]])
		ifTrue: [
			anEvent shiftPressed
				ifTrue: [ self selectPreviousTask ]
				ifFalse: [ self selectNextTask ].
			^ true ].
	^ super handleEvent: anEvent
]

{ #category : 'event handling' }
TaskListMorph >> handlesKeyboard: evt [
	"Yes, we do it here."

	^true
]

{ #category : 'testing' }
TaskListMorph >> hasCurrentWindows: currentTasks [

	^ (self tasks includesAll: currentTasks) and: [
		  currentTasks includesAll: self tasks ]
]

{ #category : 'private' }
TaskListMorph >> highlightBorderColor [

	^ Color R: 55 G: 140 B: 240
]

{ #category : 'initialization' }
TaskListMorph >> initialize [
	"Initialize the receiver."

	super initialize.
	self
		initializeTasks;
		initializeLayout;
		initializeAppearance;
		addMorphs;
		updateButtonsAndPreview
]

{ #category : 'initialization' }
TaskListMorph >> initializeAppearance [
	"Initialize the appearance. macOS-style dark rounded panel."

	self
		color: (Color black alpha: 0.7);
		borderWidth: 0;
		cornerStyle: #rounded
]

{ #category : 'initialization' }
TaskListMorph >> initializeLayout [
	"Initialize the layout."

	self
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 16;
		cellInset: 12;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : 'initialization' }
TaskListMorph >> initializeTasks [
	"Set up the current tasks."

	self tasks: self currentWorld taskbarTasks
]

{ #category : 'settings' }
TaskListMorph >> keepOpen [
	^ self class keepOpen
]

{ #category : 'event handling' }
TaskListMorph >> keyDown: event [
	"Handle Alt+Tab and Alt+Shift+Tab to cycle through tasks."

	(self class isNavigationEvent: event) ifTrue: [
		event shiftPressed
			ifTrue: [ self selectPreviousTask ]
			ifFalse: [ self selectNextTask ].
		^ true ].
	^ super keyDown: event
]

{ #category : 'private' }
TaskListMorph >> maxWidth [
	"Answer the maximum width the task list may occupy, derived from the world extent."

	^ self currentWorld width - 100
]

{ #category : 'geometry' }
TaskListMorph >> minimumExtent [
	"Answer the minimum extent."

	^(self defaultPreviewExtent x + 32 @ (self defaultPreviewExtent y + 64))
]

{ #category : 'open/close' }
TaskListMorph >> openInWorld: aWorld [

	super openInWorld: aWorld.
	self center: aWorld center.
	self wantsKeyboardFocus
		ifTrue: [self takeKeyboardFocus]
]

{ #category : 'open/close' }
TaskListMorph >> postOpenInWorld: aWorld [
	"Update the layout after opening."

	self allMorphs do: [:m | m layoutChanged].
	super postOpenInWorld: aWorld
]

{ #category : 'open/close' }
TaskListMorph >> preOpenInWorld: aWorld [

	"Do nothing"
]

{ #category : 'cycling' }
TaskListMorph >> selectNextTask [
	"Make the next task active."

	self selectTask: (self tasks
		after: self activeTask
		ifAbsent: [self tasks isEmpty
					ifFalse: [self tasks first]])
]

{ #category : 'cycling' }
TaskListMorph >> selectPreviousTask [
	"Make the previous task active."

	self selectTask: (self tasks
		before: self activeTask
		ifAbsent: [self tasks isEmpty
					ifFalse: [self tasks last]])
]

{ #category : 'private' }
TaskListMorph >> selectTask: aTask [
	"Make the given task active and update the buttons."

	self tasks do: [:t | t state: #restored].
	aTask ifNotNil: [ aTask state: #active ].
	self updateButtonsAndPreview
]

{ #category : 'stepping' }
TaskListMorph >> step [
	"Check the sensor for the command key to see if we're done."

	(self keepOpen not and: [self activeHand anyModifierKeyPressed not])
		ifTrue: [self done]
]

{ #category : 'stepping' }
TaskListMorph >> stepTime [
	"Check quickly."

	^100
]

{ #category : 'open/close' }
TaskListMorph >> takesKeyboardFocus [
	"Answer whether the receiver can normally take keyboard focus."

	^true
]

{ #category : 'accessing' }
TaskListMorph >> tasks [
	"Answer the value of tasks"

	^ tasks
]

{ #category : 'accessing' }
TaskListMorph >> tasks: anObject [
	"Set the value of tasks"

	tasks := anObject
]

{ #category : 'private' }
TaskListMorph >> uniformizeContainerWidths [
	"Make all direct children the same width (the widest), so labels are vertically aligned."

	| maxW |
	self submorphs ifEmpty: [ ^ self ].
	maxW := (self submorphs collect: [:c | c minExtent x]) max.
	self submorphs do: [:c | c width: maxW]
]

{ #category : 'private' }
TaskListMorph >> updateButtonsAndPreview [
	"Rebuild and recenter."

	self updateTaskButtons: self effectivePreviewExtent.
	self world ifNotNil: [ :w |
		self hResizing = #rigid ifFalse: [
			self extent: self minExtent.
			self hResizing: #rigid; vResizing: #rigid ].
		self center: w center ]
]

{ #category : 'private' }
TaskListMorph >> updateTaskButtons: aPreviewExtent [
	"Create clickable thumbnail morphs for all tasks, arranged horizontally.
	macOS-style: white selection glow, dimmed inactive thumbnails,
	with the task name label below each thumbnail."

	self removeAllMorphs.
	self tasks do: [:t | | container thumbWrapper thumb label scaleFactor labelTruncation labelFontSize |
		scaleFactor := aPreviewExtent x / self defaultPreviewExtent x.
		labelTruncation := (25 * scaleFactor) asInteger max: 8.
		labelFontSize := (11 * scaleFactor) asInteger max: 8.
		thumb := t morph taskThumbnailOfSize: aPreviewExtent.
		thumb extent: aPreviewExtent.
		t isActive ifFalse: [ thumb color: (Color gray: 0.4) ].
		thumbWrapper := Morph new
			changeTableLayout;
			color: Color transparent;
			borderWidth: (t isActive ifTrue: [ 4 ] ifFalse: [ 2 ]);
			borderColor: (t isActive ifTrue: [ self highlightBorderColor ] ifFalse: [ self baseBorderColor ]);
			cornerStyle: #rounded;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			yourself.
		thumbWrapper addMorphBack: thumb.
		label := StringMorph new
			contents: ((t label size > labelTruncation) ifTrue: [ (t label first: (labelTruncation - 4 max: 0)) , '...' ] ifFalse: [ t label ]);
			color: Color white;
			fontName: 'Standard' size: labelFontSize;
			yourself.
		container := Morph new
			changeTableLayout;
			listDirection: #topToBottom;
			borderWidth: (t isActive ifTrue: [ 0 ] ifFalse: [ 2 ]);
			color: Color transparent;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			cellPositioning: #center;
			cellInset: 8;
			layoutInset: 4;
			yourself.
		container addMorphBack: thumbWrapper.
		container addMorphBack: label.
		container on: #mouseUp send: #value to: [self selectTask: t; done].
		self addMorphBack: container].
	self uniformizeContainerWidths
]
