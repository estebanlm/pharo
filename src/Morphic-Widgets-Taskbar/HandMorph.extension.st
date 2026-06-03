Extension { #name : 'HandMorph' }

{ #category : '*Morphic-Widgets-Taskbar' }
HandMorph >> sendKeyboardEvent: anEvent [
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
