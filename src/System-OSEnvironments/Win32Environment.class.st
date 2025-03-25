"
I am a specialized OSEnvironment for Windows.
See my superclass to understand my common usage.

# Encoding Management

Windows hides the environment variables encoding through its API, and it's not up to the user how to encode them.
Thus, I do not propose an API to specify encodings.

# Implementation Details 

I use FFI calls to manage encodings. Pharo strings are first encoded in utf8 and used to create Win32 WideStrings, whose are used in the windows function calls.
See Win32WideString
"
Class {
	#name : 'Win32Environment',
	#superclass : 'OSEnvironment',
	#category : 'System-OSEnvironments-Platforms',
	#package : 'System-OSEnvironments',
	#tag : 'Platforms'
}

{ #category : 'testing' }
Win32Environment class >> isDefaultFor: aPlatform [
	^ aPlatform isWindows
]
