"
I'm a platform independent environment who is intent to work as fallback when none other works. 
I provide stubs for method calls that answers just default values. 

"
Class {
	#name : 'NullOSEnvironment',
	#superclass : 'OSEnvironment',
	#category : 'System-OSEnvironments-Platforms',
	#package : 'System-OSEnvironments',
	#tag : 'Platforms'
}

{ #category : 'testing' }
NullOSEnvironment class >> isAvailable [

	^ true
]
