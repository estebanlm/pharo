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
MissionControlMorphTest >> newWorld [

	| hand |
	
	hand := HandMorph new.

	^ WorldMorph new addHand: hand; activeHand: hand; yourself
]

{ #category : 'helpers' }
MissionControlMorphTest >> openTestWindows: anInteger [

	1 to: anInteger do: [ :index | | window |
		window := SystemWindow new.
		window setLabel: 'Test Window ' , index printString.
		window openInWorld: world.
		testWindows add: window
	]
]

{ #category : 'running' }
MissionControlMorphTest >> setUp [

	super setUp.
	world := self newWorld.
	testWindows := OrderedCollection new
]

{ #category : 'running' }
MissionControlMorphTest >> tearDown [

	testWindows do: [ :w | w delete ].
	super tearDown
]

{ #category : 'tests' }
MissionControlMorphTest >> testBackgroundClickDismisses [

	| missionControl event |
	
	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	missionControl := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	event := MouseButtonEvent new
		         setType: #mouseDown
		         position: world center
		         which: MouseButtonEvent redButton
		         buttons: { MouseButtonEvent redButton }
		         hand: nil
		         stamp: Time millisecondClockValue.

	missionControl handleMouseDown: event.
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testCollapsedWindowsInSpacesBar [

	| missionControl collapsedWin |

	self openTestWindows: 1.
	collapsedWin := testWindows first.
	collapsedWin collapse.
	MissionControlMorph toggleInWorld: world.
	missionControl := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	self assert: missionControl spacesBar spaceThumbnails size equals: 1
]

{ #category : 'tests' }
MissionControlMorphTest >> testEscapeDismisses [

	| missionControl event |

	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	missionControl := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	event := KeyboardEvent new
		         setType: #keystroke
		         buttons: 0
		         position: 0 @ 0
		         keyValue: Character escape asciiValue
		         charCode: Character escape asciiValue
		         hand: nil
		         stamp: Time millisecondClockValue.
		
	missionControl handleKeystroke: event.
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testLayoutDoesNotOverlap [

	| missionControl thumbBounds overlapFound |

	self openTestWindows: 5.
	MissionControlMorph toggleInWorld: world.
	missionControl := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	thumbBounds := missionControl thumbnails collect: [ :t | t bounds ].
	overlapFound := false.
	thumbBounds do: [ :r1 | thumbBounds do: [ :r2 | r1 == r2 ifFalse: [ (r1 intersects: r2) ifTrue: [ overlapFound := true ] ] ] ].
	self deny: overlapFound
]

{ #category : 'tests' }
MissionControlMorphTest >> testNoWindowsShowsEmptyMissionControl [

	MissionControlMorph toggleInWorld: world.
	self assert: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]

{ #category : 'tests' }
MissionControlMorphTest >> testThumbnailClickActivatesWindow [

	| missionControl thumb event |
	self openTestWindows: 1.
	MissionControlMorph toggleInWorld: world.
	missionControl := world submorphs detect: [ :m | m isKindOf: MissionControlMorph ].
	thumb := missionControl thumbnails first.

	event := MouseButtonEvent new
		         setType: #mouseDown
		         position: thumb center
		         which: MouseButtonEvent redButton
		         buttons: { MouseButtonEvent redButton }
		         hand: nil
		         stamp: Time millisecondClockValue.
		
	missionControl handleMouseDown: event.
	self assert: testWindows first isActive
]

{ #category : 'tests' }
MissionControlMorphTest >> testThumbnailCreation [

	self openTestWindows: 3.
	MissionControlMorph toggleInWorld: world.
	self assert: (world submorphs detect: [ :m | m isKindOf: MissionControlMorph ] ifNone: [ nil ]) thumbnails size equals: 3
]

{ #category : 'tests' }
MissionControlMorphTest >> testToggleActivation [

	MissionControlMorph toggleInWorld: world.
	self assert: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ]).
	
	MissionControlMorph toggleInWorld: world.
	self deny: (world submorphs anySatisfy: [ :m | m isKindOf: MissionControlMorph ])
]
