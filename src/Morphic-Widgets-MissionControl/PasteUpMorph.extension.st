Extension { #name : 'PasteUpMorph' }

{ #category : '*Morphic-Widgets-MissionControl' }
PasteUpMorph class >> buildMissionControlShortcutsOn: aBuilder [
	<keymap>
	(aBuilder shortcut: #missionControl)
		category: #MorphCtrlNavigation;
		default: Character arrowUp meta;
		do: [ :target | target world missionControl ];
		description: 'Toggle Mission Control view of all windows'.
	(aBuilder shortcut: #dismissMissionControl)
		category: #MorphCtrlNavigation;
		default: Character arrowDown meta;
		do: [ :target | target world dismissMissionControl ];
		description: 'Dismiss Mission Control'.
	(aBuilder shortcut: #missionControlF3)
		category: #MorphCtrlNavigation;
		default: KeyboardKey F3;
		do: [ :target | target world missionControl ];
		description: 'Toggle Mission Control view of all windows (alternate)'
]
