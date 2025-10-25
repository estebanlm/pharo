Class {
	#name : 'BaselineOfFonts',
	#superclass : 'BaselineOf',
	#instVars : [
		'initializersEnabled'
	],
	#category : 'BaselineOfFonts',
	#package : 'BaselineOfFonts'
}

{ #category : 'baselines' }
BaselineOfFonts >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec preLoadDoIt: #preload:package:.
			spec postLoadDoIt: #postload:package:.

			spec
				package: 'Fonts-Abstract';
				package: 'Fonts-Infrastructure' with: [ spec requires: #( 'Fonts-Abstract' ) ];
				package: 'Fonts-Infrastructure-Tests' with: [ spec requires: #( 'Fonts-Infrastructure' ) ];
				package: 'Text-Core' with: [ spec requires: #( 'Fonts-Infrastructure' ) ];
				package: 'Graphics-Fonts' with: [ spec requires: #( 'Fonts-Abstract' 'Fonts-Infrastructure' 'Text-Core' ) ].

			spec
				group: 'Core' with: #( 'Fonts-Abstract' 'Fonts-Infrastructure' );
				group: 'Tests' with: #( 'Fonts-Infrastructure-Tests' ) ]
]

{ #category : 'actions' }
BaselineOfFonts >> postload: loader package: packageSpec [

	MCMethodDefinition initializersEnabled: initializersEnabled
]

{ #category : 'actions' }
BaselineOfFonts >> preload: loader package: packageSpec [
	"For now we ensure the class initialization but in the future it should be true by default"

	initializersEnabled := MCMethodDefinition initializersEnabled.
	MCMethodDefinition initializersEnabled: true
]
