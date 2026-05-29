Extension { #name : 'PasteUpMorph' }

{ #category : '*Morphic-Widgets-MissionControl' }
PasteUpMorph class >> buildMissionControlShortcutsOn: aBuilder [
	<keymap>
	(aBuilder shortcut: #missionControl)
		category: #WindowShortcuts;
		default: $u ctrl;
		do: [ :target | target world missionControl ];
		description: 'Toggle Mission Control view of all windows'
]
