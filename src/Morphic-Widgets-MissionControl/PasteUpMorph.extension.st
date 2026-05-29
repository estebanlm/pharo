Extension { #name : 'PasteUpMorph' }

{ #category : '*Morphic-Widgets-MissionControl' }
PasteUpMorph class >> buildMissionControlShortcutsOn: aBuilder [
	<keymap>
	(aBuilder shortcut: #missionControl)
		category: #WindowShortcuts;
		default: Character arrowUp ctrl;
		do: [ :target | target world missionControl ];
		description: 'Toggle Mission Control view of all windows'.
	(aBuilder shortcut: #missionControlF3)
		category: #WindowShortcuts;
		default: KeyboardKey F3;
		do: [ :target | target world missionControl ];
		description: 'Toggle Mission Control view of all windows (alternate)'
]
