Extension { #name : 'HandMorph' }

{ #category : '*Morphic-Widgets-Taskbar' }
HandMorph >> sendKeyboardEvent: anEvent [
	"Sync recentModifiers from every keyboard event.
	OSWindow events bypass the old VM pipeline that used to update
	recentModifiers via the sensor, so we convert the event's buttons
	(new-format: Alt=32, Cmd=64, Ctrl=16) to the old-format bits
	(Alt=4, Cmd=8, Ctrl=2) that anyModifierKeyPressed expects."

	self updateRecentModifiersFromEvent: anEvent.

	"Intercept Alt+Tab (and Alt+Shift+Tab) navigation events before they
	reach the keyboard focus holder. When a morph like a text editor has
	focus, the event would otherwise be consumed without reaching world
	navigation."

	(anEvent isKeyDown and: [ TaskListMorph isNavigationEvent: anEvent ])
		ifTrue: [
			self owner ifNotNil: [ :world |
				world navigationKey: anEvent.
				anEvent supressNextKeyPress: true.
				^ self ] ].

	^ self
		sendEvent: anEvent
		focus: self keyboardFocus
		clear: [ self keyboardFocus: nil ]
]

{ #category : '*Morphic-Widgets-Taskbar' }
HandMorph >> updateRecentModifiersFromEvent: anEvent [
	"Update recentModifiers from the event's buttons field,
	converting new-format modifier bits to old-format bits."

	| buttons |
	buttons := anEvent buttons.
	recentModifiers := 0.
	(buttons anyMask: UserInputEvent altKeyMask) ifTrue: [ recentModifiers := recentModifiers bitOr: 4 ].
	(buttons anyMask: UserInputEvent cmdKeyMask) ifTrue: [ recentModifiers := recentModifiers bitOr: 8 ].
	(buttons anyMask: UserInputEvent ctrlKeyMask) ifTrue: [ recentModifiers := recentModifiers bitOr: 2 ]
]
