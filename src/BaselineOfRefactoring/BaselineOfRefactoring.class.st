Class {
	#name : 'BaselineOfRefactoring',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRefactoring',
	#package : 'BaselineOfRefactoring'
}

{ #category : 'baselines' }
BaselineOfRefactoring >> baseline: spec [

	<baseline>
	| repository |
	repository := (self classNamed: #BaselineOfPharo) specRepository.
	spec
		baseline: 'Spec2' with: [ spec loads: #( 'Core' ) ];
		baseline: 'Commander2' with: [ spec loads: #( 'Core' ) ].
	spec package: 'Regex-Core'.
	spec
		package: 'Refactoring-Environment';
		package: 'Refactoring-Changes' with: [ spec requires: #( 'Refactoring-Environment' ) ];
		package: 'Refactoring-CompilerSupport';
		package: 'Refactoring-Core'
		with: [ spec requires: #( 'Refactoring-Changes' 'Refactoring-Environment' 'Refactoring-CompilerSupport' ) ];
		package: 'Refactoring-Conditions' with: [ spec requires: #( 'Refactoring-Core' 'Refactoring-CompilerSupport' ) ];
		package: 'Refactoring-Transformations'
		with: [ spec requires: #( 'Regex-Core' 'Refactoring-Core' 'Refactoring-Conditions' 'Refactoring-CompilerSupport' ) ];
		package: 'Refactoring-UI' with: [ spec requires: #( 'Refactoring-Transformations' 'Spec2' 'Commander2' ) ];
		package: 'Refactoring-DataForTesting'
		with: [ spec requires: #( 'Refactoring-Core' 'Refactoring-Environment' 'Refactoring-Changes' ) ];
		package: 'Refactoring-CompilerSupport-Tests' with: [ spec requires: #( 'Refactoring-CompilerSupport' ) ];
		package: 'Refactoring-UI-Tests' with: [ spec requires: #( 'Refactoring-DataForTesting' 'Refactoring-UI' ) ];
		package: 'Refactoring-Core-Tests' with: [ spec requires: #( 'Refactoring-Core' ) ];
		package: 'Refactoring-Changes-Tests' with: [ spec requires: #( 'Refactoring-Changes' ) ];
		package: 'Refactoring-Critics-Tests';
		package: 'Refactoring-Environment-Tests' with: [ spec requires: #( 'Refactoring-Environment' ) ];
		package: 'Refactoring-Transformations-Tests' with: [ spec requires: #( 'Refactoring-Transformations' ) ];
		group: 'Core'
		with: #( 'Refactoring-Changes' 'Refactoring-Conditions' 'Refactoring-Core' 'Refactoring-UI' 'Refactoring-Environment'
			   'Refactoring-Transformations' );
		group: 'Tests'
		with: #( 'Refactoring-Core-Tests' 'Refactoring-Changes-Tests' 'Refactoring-Critics-Tests' 'Refactoring-Environment-Tests'
			   'Refactoring-UI-Tests' 'Refactoring-Transformations-Tests' )
]
