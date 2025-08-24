"
Tracks how often completion entries are used
"
Class {
	#name : 'NECUsageTracker',
	#superclass : 'Object',
	#classVars : [
		'UsageCounts'
	],
	#category : 'NECompletion-Model',
	#package : 'NECompletion',
	#tag : 'Model'
}

{ #category : 'tracking' }
NECUsageTracker class >> incrementUsageFor: aString [
	UsageCounts ifNil: [ UsageCounts := Dictionary new ].
	UsageCounts at: aString ifAbsentPut: [ 0 ].
	UsageCounts at: aString put: (UsageCounts at: aString) + 1.
]

{ #category : 'tracking' }
NECUsageTracker class >> usageCountFor: aString [
	UsageCounts ifNil: [ ^ 0 ].
	^ UsageCounts at: aString ifAbsent: [ 0 ].

]
