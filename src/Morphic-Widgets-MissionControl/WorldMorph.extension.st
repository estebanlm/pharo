Extension { #name : 'WorldMorph' }

{ #category : '*Morphic-Widgets-MissionControl' }
WorldMorph >> missionControl [
	"Toggle Mission Control."
	MissionControlMorph toggleInWorld: self
]
