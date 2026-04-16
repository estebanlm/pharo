Class {
	#name : 'BaselineOfSystemPlatforms',
	#superclass : 'Object',
	#category : 'BaselineOfSystemPlatforms',
	#package : 'BaselineOfSystemPlatforms'
}

{ #category : 'baselines' }
BaselineOfSystemPlatforms >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec 
            package: 'System-Platforms-Tests'.
            
        spec 
            group: 'Tests' with: #('System-Platforms-Tests') 
    ]
]
