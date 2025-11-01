Class {
	#name : 'BaselineOfUIInfrastructure',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfUIInfrastructure',
	#package : 'BaselineOfUIInfrastructure'
}

{ #category : 'baselines' }
BaselineOfUIInfrastructure >> baseline: spec [

	<baseline>
	| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [

			spec baseline: 'Display' with: [ spec repository: repository ].
			spec baseline: 'Fonts' with: [
					spec
						repository: repository;
						loads: #Core ].
			spec baseline: 'FreeType' with: [
					spec
						repository: repository;
						loads: 'ui' ] ]
]
