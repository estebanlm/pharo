"
I am a specialized OSEnvironment version for *nix systems (Linux, OSX).
See my superclass to understand my common usage.

# Encoding Management

I provide a variant of the Dictionary-like API that receives an extra argument specifying an encoding.
Valid encodings are those specified by the Zinc-Character-Encoding-* packages.
The API accepts both encoding objects and symbols which are used to lookup encodings.

For example, the following usages are valid:

OSEnvironment current at: 'HOME' encoding: #utf8.
OSEnvironment current at: 'HOME' encoding: #utf8 asZnCharacterEncoder.
OSEnvironment current at: 'HOME' encoding: ZnCharacterEncoder utf8.

# Implementation Details

I try to use a primitive to get/set environment variables, and if it fails or it is not available, I use corresponding ffi calls using byteArrays with encoded strings as argument.
"
Class {
	#name : 'UnixEnvironment',
	#superclass : 'OSEnvironment',
	#category : 'System-OSEnvironments-Platforms',
	#package : 'System-OSEnvironments',
	#tag : 'Platforms'
}

{ #category : 'testing' }
UnixEnvironment class >> isDefaultFor: aPlatform [
	^  aPlatform isUnix
		or: [ aPlatform isMacOSX
		or: [ aPlatform isMacOS ] ]
]
