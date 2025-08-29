Extension { #name : 'Morph' }

{ #category : '*Polymorph-Widgets' }
Morph >> morphicUIManager [

	^ MorphicUIManager new
]

{ #category : '*Polymorph-Widgets' }
Morph >> passivate [
	"Mark the receiver and submorphs as passive (background)."

	self submorphsDo: [:m | m passivate]
]

{ #category : '*Polymorph-Widgets' }
Morph >> preferredCornerStyle [
	"Answer the preferred corner style."

	^#square
]

{ #category : '*Polymorph-Widgets-Themes' }
Morph class >> systemIconName [

	^ #morph
]

{ #category : '*Polymorph-Widgets' }
Morph class >> theme [
	"Answer the ui theme that provides controls."

	^ Smalltalk ui theme
]
