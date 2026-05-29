Class {
	#name : 'MissionControlMorphTest',
	#superclass : 'TestCase',
	#instVars : [
		'world',
		'testWindows'
	],
	#category : 'Morphic-Widgets-MissionControl-Tests',
	#package : 'Morphic-Widgets-MissionControl-Tests'
}

{ #category : 'running' }
MissionControlMorphTest >> setUp [
	super setUp.
	world := WorldMorph new.
	testWindows := OrderedCollection new
]

{ #category : 'running' }
MissionControlMorphTest >> tearDown [
	testWindows do: [ :w | w delete ].
	super tearDown
]

{ #category : 'helpers' }
MissionControlMorphTest >> openTestWindows: anInteger [
	1 to: anInteger do: [ :i |
		| w |
		w := SystemWindow new.
		w title: 'Test Window ', i printString.
		w openInWorld: world.
		testWindows add: w ]
]

{ #category : 'tests' }
MissionControlMorphTest >> testToggleActivation [
	MissionControlMorph toggleInWorld: world.
	self assert: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ]).
	MissionControlMorph toggleInWorld: world.
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testThumbnailCreation [
	self openTestWindows: 3.
	MissionControlMorph toggleInWorld: world.
	self
		assert:
			((world submorphs
				detect: [ :m | m isKindOf: MissionControlMorph ]
				ifNone: [ nil ]) thumbnails size)
		equals: 3
]

{ #category : 'tests' }
MissionControlMorphTest >> testThumbnailClickActivatesWindow [
	| mc thumb |
	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	mc := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	thumb := mc thumbnails first.
	mc handleMouseDown: (MouseButtonEvent new
		setType: #mouseDown
		position: thumb center
		which: MouseButtonEvent redButton
		hand: nil
		stamp: Time millisecondClockValue).
	self assert: testWindows first isActive
]

{ #category : 'tests' }
MissionControlMorphTest >> testBackgroundClickDismisses [
	| mc |
	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	mc := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	mc handleMouseDown: (MouseButtonEvent new
		setType: #mouseDown
		position: world center
		which: MouseButtonEvent redButton
		hand: nil
		stamp: Time millisecondClockValue).
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testEscapeDismisses [
	| mc |
	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	mc := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	mc handleKeystroke: (KeyboardEvent new
		setType: #keystroke
		buttons: 0
		position: 0 @ 0
		keyValue: Character escape asciiValue
		charCode: Character escape asciiValue
		hand: nil
		stamp: Time millisecondClockValue).
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testCollapsedWindowsInSpacesBar [
	| mc collapsedWin |
	self openTestWindows: 1.
	collapsedWin := testWindows first.
	collapsedWin collapse.
	MissionControlMorph toggleInWorld: world.
	mc := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	self assert: mc spacesBar spaceThumbnails size equals: 1
]

{ #category : 'tests' }
MissionControlMorphTest >> testNoWindowsShowsEmptyMissionControl [
	MissionControlMorph toggleInWorld: world.
	self assert: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testLayoutDoesNotOverlap [
	| mc thumbBounds overlapFound |
	self openTestWindows: 5.
	MissionControlMorph toggleInWorld: world.
	mc := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	thumbBounds := mc thumbnails collect: [ :t | t bounds ].
	overlapFound := false.
	thumbBounds do: [ :r1 |
		thumbBounds do: [ :r2 |
			r1 == r2 ifFalse: [
				(r1 intersects: r2) ifTrue: [ overlapFound := true ] ] ] ].
	self deny: overlapFound
]
