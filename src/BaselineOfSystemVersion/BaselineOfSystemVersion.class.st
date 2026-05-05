Class {
	#name : 'BaselineOfSystemVersion',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSystemVersion',
	#package : 'BaselineOfSystemVersion'
}

{ #category : 'baselines' }
BaselineOfSystemVersion >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'System-Version';
				package: 'System-Version-Tests' with: [ spec requires: #( 'System-Version' ) ].

			spec
				group: 'Core' with: { 'System-Version' };
				group: 'Tests' with: { 'System-Version-Tests' } ]
]
