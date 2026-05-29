Extension { #name : 'WorldMorph' }

{ #category : '*Morphic-Widgets-MissionControl' }
WorldMorph >> missionControl [
	"Toggle Mission Control."
	MissionControlMorph toggleInWorld: self
]

{ #category : '*Morphic-Widgets-MissionControl' }
WorldMorph >> dismissMissionControl [
	"Dismiss Mission Control if active."
	| current |
	current := self submorphs
		detect: [ :m | m isKindOf: MissionControlMorph ]
		ifNone: [ nil ].
	current ifNotNil: [ current deactivate ]
]

{ #category : '*Morphic-Widgets-MissionControl' }
WorldMorph >> handlesKeyDown: anEvent [
	(anEvent commandKeyPressed and: [ anEvent keyValue = 30 ]) ifTrue: [ ^ true ].
	(anEvent commandKeyPressed and: [ anEvent keyValue = 31 ]) ifTrue: [ ^ true ].
	anEvent key = KeyboardKey F3 ifTrue: [ ^ true ].
	^ false
]

{ #category : '*Morphic-Widgets-MissionControl' }
WorldMorph >> keyDown: anEvent [
	(anEvent commandKeyPressed and: [ anEvent keyValue = 30 ]) ifTrue: [ ^ self missionControl ].
	(anEvent commandKeyPressed and: [ anEvent keyValue = 31 ]) ifTrue: [ ^ self dismissMissionControl ].
	anEvent key = KeyboardKey F3 ifTrue: [ ^ self missionControl ].
	super keyDown: anEvent
]
