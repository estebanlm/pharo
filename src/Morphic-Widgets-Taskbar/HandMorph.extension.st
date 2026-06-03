Extension { #name : 'HandMorph' }

{ #category : '*Morphic-Widgets-Taskbar' }
HandMorph >> sendKeyboardEvent: anEvent [
	"Track modifier key state via explicit keyDown/keyUp events.
	OSWindow events bypass the old VM pipeline that used to update
	recentModifiers, so we must update it here for the step method
	in TaskListMorph to detect modifier release."

	anEvent isKeyDown ifTrue: [
		anEvent key ifNotNil: [ :key |
			(key = KeyboardKey altLeft or: [ key = KeyboardKey altRight ])
				ifTrue: [ recentModifiers := recentModifiers bitOr: 4 ].
			(key = KeyboardKey superLeft or: [ key = KeyboardKey superRight ])
				ifTrue: [ recentModifiers := recentModifiers bitOr: 8 ].
			(key = KeyboardKey controlLeft or: [ key = KeyboardKey controlRight ])
				ifTrue: [ recentModifiers := recentModifiers bitOr: 2 ] ] ].
	anEvent isKeyUp ifTrue: [
		anEvent key ifNotNil: [ :key |
			(key = KeyboardKey altLeft or: [ key = KeyboardKey altRight ])
				ifTrue: [ recentModifiers := recentModifiers bitClear: 4 ].
			(key = KeyboardKey superLeft or: [ key = KeyboardKey superRight ])
				ifTrue: [ recentModifiers := recentModifiers bitClear: 8 ].
			(key = KeyboardKey controlLeft or: [ key = KeyboardKey controlRight ])
				ifTrue: [ recentModifiers := recentModifiers bitClear: 2 ] ] ].

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
