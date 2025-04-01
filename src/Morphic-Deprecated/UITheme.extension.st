Extension { #name : 'UITheme' }

{ #category : '*Morphic-Deprecated' }
UITheme >> newListIn: aThemedMorph for: aModel list: listSelector selected: getSelector changeSelected: setSelector icon: iconSelector getEnabled: enabledSel help: helpText [
	"Answer an icon list for the given model."

	^PluggableIconListMorph new
		selectionColor: self selectionColor;
		textColor: self listTextColor;
		font: self listFont;
		on: aModel
		list: listSelector
		selected: getSelector
		changeSelected: setSelector
		menu: nil
		keystroke: nil;
		autoDeselect: false;
		cornerStyle: aThemedMorph preferredCornerStyle;
		color: Color white;
		borderStyle: (BorderStyle inset width: 1 scaledByDisplayScaleFactor);
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		getIconSelector: iconSelector;
		getEnabledSelector: enabledSel;
		setBalloonText: helpText
]

{ #category : '*Morphic-Deprecated' }
UITheme >> newMorphListIn: aThemedMorph for: aModel list: listSelector getSelected: getSelector setSelected: setSelector getEnabled: enabledSel help: helpText [
	"Answer a morph list for the given model."

	^(PluggableMorphListMorph
			on: aModel
			list: listSelector
			selected: getSelector
			changeSelected: setSelector
			menu: nil
			keystroke: nil)
		selectionColor: self selectionColor;
		autoDeselect: false;
		cornerStyle: aThemedMorph preferredCornerStyle;
		color: Color white;
		borderStyle: (BorderStyle inset width: 1 scaledByDisplayScaleFactor);
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		getEnabledSelector: enabledSel;
		setBalloonText: helpText
]

{ #category : '*Morphic-Deprecated' }
UITheme >> newSliderIn: aThemedMorph for: aModel getValue: getSel setValue: setSel min: min max: max quantum: quantum getEnabled: enabledSel help: helpText [
	"Answer a slider. Resizing set for horizontal usage by default."

	^ (PluggableSliderMorph
		   on: aModel
		   getValue: getSel
		   setValue: setSel
		   min: min
		   max: max
		   quantum: quantum)
		  getEnabledSelector: enabledSel;
		  hResizing: #spaceFill;
		  vResizing: #shrinkWrap;
		  setBalloonText: helpText;
		  minHeight: 16 scaledByDisplayScaleFactor
]
