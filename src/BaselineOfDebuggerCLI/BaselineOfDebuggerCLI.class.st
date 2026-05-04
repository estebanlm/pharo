Class {
	#name : 'BaselineOfDebuggerCLI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDebuggerCLI',
	#package : 'BaselineOfDebuggerCLI'
}

{ #category : 'baselines' }
BaselineOfDebuggerCLI >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'debugger-CLI';
				package: 'debugger-CLI-Tests' with: [ spec requires: #( 'debugger-CLI' ) ].

			spec
				group: 'Core' with: { 'debugger-CLI' };
				group: 'Tests' with: { 'debugger-CLI-Tests' } ]
]
