Extension { #name : 'WorldMorph' }

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
WorldMorph >> missionControl [
	"Toggle Mission Control."
	MissionControlMorph toggleInWorld: self
]
