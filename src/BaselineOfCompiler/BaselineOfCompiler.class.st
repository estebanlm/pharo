Class {
	#name : 'BaselineOfCompiler',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCompiler',
	#package : 'BaselineOfCompiler'
}

{ #category : 'accessing' }
BaselineOfCompiler class >> corePackageNames [

	^ self packagesOfGroupNamed: #Core
]

{ #category : 'baselines' }
BaselineOfCompiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'UIManager';
				package: 'AST-Core';
				package: 'Collections-Arithmetic';
				package: 'Collections-Atomic';
				package: 'Collections-Stack';
				package: 'CodeImport';
				package: 'CodeImport-Commands';
				package: 'DebugInfo';
				package: 'NumberParser';
				package: 'OpalCompiler-Core';
				package: 'ParseTreeRewriter';
				package: 'Deprecation'.

			spec
				group: 'Core'
				with:
					{ 'UIManager'. 'AST-Core'. 'Collections-Arithmetic'. 'Collections-Atomic'. 'Collections-Stack'. 'CodeImport'. 'CodeImport-Commands'. 'DebugInfo'.
					'NumberParser'. 'OpalCompiler-Core'. 'ParseTreeRewriter'. 'Deprecation' } ]
]
