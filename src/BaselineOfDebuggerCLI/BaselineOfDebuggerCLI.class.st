Class {
	#name : 'BaselineOfDebuggerCLI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDebuggerCLI',
	#package : 'BaselineOfDebuggerCLI'
}

{ #category : 'baselines' }
BaselineOfDebuggerCLI >> baseline: spec [

	<baseline>
	| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [
			spec
				baseline: 'Debugging' with: [
						spec
							repository: repository;
							loads: #( 'Debugger-Model' ) ];
				package: 'debugger-CLI' with: [ spec requires: #( 'Debugging' ) ];
				package: 'debugger-CLI-Tests' with: [ spec requires: #( 'debugger-CLI' Debugging ) ].

			spec
				group: 'Core' with: { 'debugger-CLI' };
				group: 'Tests' with: { 'debugger-CLI-Tests' } ]
]
