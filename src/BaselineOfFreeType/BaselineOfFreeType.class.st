Class {
	#name : 'BaselineOfFreeType',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFreeType',
	#package : 'BaselineOfFreeType'
}

{ #category : 'baselines' }
BaselineOfFreeType >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		spec package: 'FreeType'.
		spec package: 'FreeType-Graphics' with: [ spec requires: #('FreeType') ].	
		spec package: 'FreeType-Tests' with: [ spec requires: #('FreeType') ].

		spec group: 'core' with: #('FreeType').
		spec group: 'ui' with: #('core' 'FreeType-Graphics').
		spec group: 'tests' with: #('core' 'FreeType-Tests') ]
]

{ #category : 'accessing' }
BaselineOfFreeType >> project [
	
	| aProject |
	
	aProject := super project.
	aProject loadType: #atomic.
	^ aProject
]
