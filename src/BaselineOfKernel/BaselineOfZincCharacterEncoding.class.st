Class {
	#name : 'BaselineOfZincCharacterEncoding',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfKernel',
	#package : 'BaselineOfKernel'
}

{ #category : 'accessing' }
BaselineOfZincCharacterEncoding class >> additionalPackagesPackageNames [

	^ self packagesOfGroupNamed: #AdditionalPackages
]

{ #category : 'accessing' }
BaselineOfZincCharacterEncoding class >> corePackageNames [

	^ self packagesOfGroupNamed: #Core
]

{ #category : 'accessing' }
BaselineOfZincCharacterEncoding class >> testsPackageNames [

	^ self packagesOfGroupNamed: #Tests
]

{ #category : 'baselines' }
BaselineOfZincCharacterEncoding >> baseline: spec [

    <baseline>

    spec for: #common do: [
        spec 
            package: 'Zinc-Character-Encoding-Core';
            package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: #('Zinc-Character-Encoding-Core') ].
        
        spec 
            group: 'Core' with: #('Zinc-Character-Encoding-Core');
            group: 'Tests' with: #('Zinc-Character-Encoding-Tests') ]
]
