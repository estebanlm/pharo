Extension { #name : 'TEasilyThemed' }

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newBracketSliderFor: aModel getValue: getSel setValue: setSel min: minValue max: maxValue quantum: quantum help: helpText [
	"Answer a bracket slider with the given selectors."

	^self
		newBracketSliderFor: aModel
		getValue: getSel
		setValue: setSel
		min: minValue
		max: maxValue
		quantum: quantum
		getEnabled: nil
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newListFor: aModel list: listSelector selected: getSelector changeSelected: setSelector getEnabled: enabledSel help: helpText [
	"Answer a list for the given model."

	^self theme
		newListIn: self
		for: aModel
		list: listSelector
		selected: getSelector
		changeSelected: setSelector
		getEnabled: enabledSel
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newListFor: aModel list: listSelector selected: getSelector changeSelected: setSelector help: helpText [
	"Answer a list for the given model."

	^self
		newListFor: aModel
		list: listSelector
		selected: getSelector
		changeSelected: setSelector
		getEnabled: nil
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newListFor: aModel list: listSelector selected: getSelector changeSelected: setSelector icon: iconSelector getEnabled: enabledSel help: helpText [
	"Answer a list for the given model."

	^self theme
		newListIn: self
		for: aModel
		list: listSelector
		selected: getSelector
		changeSelected: setSelector
		icon: iconSelector
		getEnabled: enabledSel
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newMorphListFor: aModel list: listSelector getSelected: getSelector setSelected: setSelector getEnabled: enabledSel help: helpText [
	"Answer a morph list for the given model."

	^self theme
		newMorphListIn: self
		for: aModel
		list: listSelector
		getSelected: getSelector
		setSelected: setSelector
		getEnabled: enabledSel
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newMorphListFor: aModel list: listSelector getSelected: getSelector setSelected: setSelector help: helpText [
	"Answer a morph list for the given model."

	^self
		newMorphListFor: aModel
		list: listSelector
		getSelected: getSelector
		setSelected: setSelector
		getEnabled: nil
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newSliderFor: aModel getValue: getSel setValue: setSel getEnabled: enabledSel help: helpText [
	"Answer a slider with the given selectors."

	^self theme
		newSliderIn: self
		for: aModel
		getValue: getSel
		setValue: setSel
		min: 0
		max: 1
		quantum: nil
		getEnabled: enabledSel
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newSliderFor: aModel getValue: getSel setValue: setSel help: helpText [
	"Answer a slider with the given selectors."

	^self theme
		newSliderIn: self
		for: aModel
		getValue: getSel
		setValue: setSel
		min: 0
		max: 1
		quantum: nil
		getEnabled: nil
		help: helpText
]

{ #category : '*Morphic-Deprecated' }
TEasilyThemed >> newSliderFor: aModel getValue: getSel setValue: setSel min: min max: max quantum: quantum getEnabled: enabledSel help: helpText [
	"Answer a slider with the given selectors."

	^self theme
		newSliderIn: self
		for: aModel
		getValue: getSel
		setValue: setSel
		min: min
		max: max
		quantum: quantum
		getEnabled: enabledSel
		help: helpText
]
