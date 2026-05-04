Class {
	#name : 'BaselineOfSystemSupport',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSystemSupport',
	#package : 'BaselineOfSystemSupport'
}

{ #category : 'baselines' }
BaselineOfSystemSupport >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'System-Support';
				package: 'System-Support-Tests' with: [ spec requires: #( 'System-Support' ) ].

			spec
				group: 'Core' with: { 'System-Support' };
				group: 'Tests' with: { 'System-Support-Tests' } ]
]
