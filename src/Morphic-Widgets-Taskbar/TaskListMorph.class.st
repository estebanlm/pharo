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
		'tasks',
		'taskList',
		'preview'
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
	"Add our morphs. macOS-style layout: horizontal thumbnails on top, task name below."

	| mainColumn |
	self taskList: self newTasksMorph.
	self preview: self newPreviewMorph.
	mainColumn := self theme newColumnIn: self for: {
		self taskList.
		self preview }.
	mainColumn
		vResizing: #shrinkWrap;
		cellInset: 4;
		cellPositioning: #center.
	self addMorph: mainColumn.
	self layoutChanged
]

{ #category : 'private' }
TaskListMorph >> defaultPreviewExtent [
	"Answer the default extent for each individual task thumbnail."

	^(120@90) scaledByDisplayScaleFactor
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

{ #category : 'event handling' }
TaskListMorph >> handlesKeyboard: evt [
	"Yes, we do it here."

	^true
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

{ #category : 'event handling' }
TaskListMorph >> handleEvent: anEvent [
	"Handle Alt+Tab navigation directly to avoid wasHandled flag issues.
	When a SystemWindow delegates navigationKey: to the world, the event
	arrives here already marked as handled, which would skip handleKeyDown:.
	
	Only process keyDown events — keyUp also reaches here via
	sendFocusEvent:to:clear: and would produce a duplicate step."

	anEvent isKeyboard and: [anEvent isKeyDown and: [self class isNavigationEvent: anEvent]]
		ifTrue: [
			anEvent shiftPressed
				ifTrue: [ self selectPreviousTask ]
				ifFalse: [ self selectNextTask ].
			^ true ].
	^ super handleEvent: anEvent
]

{ #category : 'testing' }
TaskListMorph >> hasCurrentWindows: currentTasks [

	^ (self tasks includesAll: currentTasks) and: [
		  currentTasks includesAll: self tasks ]
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
		layoutInset: 16;
		cellInset: 8;
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

{ #category : 'geometry' }
TaskListMorph >> minimumExtent [
	"Answer the minimum extent."

	^(200 @ (self defaultPreviewExtent y + 64))
]

{ #category : 'instance creation' }
TaskListMorph >> newPreviewMorph [
	"Answer a new task name label."

	^ StringMorph new
		contents: '';
		color: Color white;
		yourself
]

{ #category : 'instance creation' }
TaskListMorph >> newTasksMorph [
	"Answer a new horizontal task thumbnail strip."

	^Morph new
		changeTableLayout;
		listDirection: #leftToRight;
		wrapDirection: #topToBottom;
		cellInset: 12;
		color: Color transparent;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : 'open/close' }
TaskListMorph >> openInWorld: aWorld [

	super openInWorld: aWorld.
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

{ #category : 'accessing' }
TaskListMorph >> preview [
	"Answer the value of preview"

	^ preview
]

{ #category : 'accessing' }
TaskListMorph >> preview: anObject [
	"Set the value of preview"

	preview := anObject
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

{ #category : 'private' }
TaskListMorph >> taskClicked: aTask [
	"A button for a task has been pressed.
	Close after selecting."

	self selectTask: aTask.
	self done
]

{ #category : 'accessing' }
TaskListMorph >> taskList [
	"Answer the value of taskList"

	^ taskList
]

{ #category : 'accessing' }
TaskListMorph >> taskList: anObject [
	"Set the value of taskList"

	taskList := anObject
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
TaskListMorph >> updateButtonsAndPreview [
	"Update the buttons and the preview.."

	self
		updateTaskButtons;
		updatePreview.
	self world ifNotNil:
		[self center: self world center]
]

{ #category : 'private' }
TaskListMorph >> updatePreview [
	"Update the task name label."

	self preview contents: (self activeTask
		ifNil: ['']
		ifNotNil: [:t | t label])
]

{ #category : 'private' }
TaskListMorph >> updateTaskButtons [
	"Create clickable thumbnail morphs for all tasks, arranged horizontally.
	macOS-style: white selection glow, dimmed inactive thumbnails."

	self taskList removeAllMorphs.
	self tasks do: [:t | | container thumb |
		thumb := t morph taskThumbnailOfSize: self defaultPreviewExtent.
		t isActive ifFalse: [ thumb color: (Color gray: 0.4) ].
		container := Morph new
			changeTableLayout;
			color: Color transparent;
			borderWidth: 3;
			borderColor: (t isActive ifTrue: [Color white] ifFalse: [Color transparent]);
			cornerStyle: #rounded;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			yourself.
		container addMorph: thumb.
		container on: #mouseUp send: #value to: [self selectTask: t; done].
		self taskList addMorphBack: container]
]
