"
I provide a simple mapping from high-level commands to low-level terminal character sequences.

"
Class {
	#name : 'NullTermInfo',
	#superclass : 'Object',
	#category : 'System-CommandLine-TextSupport',
	#package : 'System-CommandLine-TextSupport'
}

{ #category : 'instance creation' }
NullTermInfo >> on: aStream [
	"Null"
	^self
]

{ #category : 'term style' }
NullTermInfo >> set: aString [
	^ aString
]
