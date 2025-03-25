"
I am a platform to manage common features between linux and macOS since macOS is also unix.
"
Class {
	#name : 'AbstractUnixPlatform',
	#superclass : 'OSPlatform',
	#category : 'System-Platforms-Unix',
	#package : 'System-Platforms',
	#tag : 'Unix'
}

{ #category : 'testing' }
AbstractUnixPlatform class >> isAbstract [

	^ self = AbstractUnixPlatform
]

{ #category : 'environment' }
AbstractUnixPlatform >> at: aKey encoding: anEncoding ifAbsent: aBlock [
	"Gets the value of an environment variable called `aKey`.
	Execute aBlock if absent.
	Use `anEncoding` to encode the arguments and return values.

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	| result |
	result := self rawAt: (aKey encodeWith: anEncoding) ifAbsent: [ ^ aBlock value ].
	^ result decodeWith: anEncoding
]

{ #category : 'environment' }
AbstractUnixPlatform >> at: aKey put: aValue encoding: anEncoding [
	"Sets the value of an environment variable called `aKey` to `aValue`.
	Use `anEncoding` to encode both arguments.

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	^ self rawAt: (aKey encodeWith: anEncoding) put: (aValue encodeWith: anEncoding)
]

{ #category : 'environment' }
AbstractUnixPlatform >> basicGetEnvRaw: encodedVariableName [

	"PRIVATE: This primitive call works on Strings, while the correct way to manage encodings is with raw data.
	Use me through #rawAt: to correctly marshall data."

	"Gets the value of an environment variable called `anEncodedVariableName` already encoded but in ByteString form."

	<primitive: 'primitiveGetenv' module: '' error: ec>
	ec ifNil: [ ^ (self basicGetEnvRawViaFFI: encodedVariableName asString) asByteArray].
	self primitiveFail
]

{ #category : 'environment' }
AbstractUnixPlatform >> basicGetEnvRawViaFFI: arg1 [

	"PRIVATE: This FFI call works on Strings, while the correct way to manage encodings is with raw data.
	Use me through #basicGetEnvRaw: to correctly marshall data."

	"This method calls the Standard C Library getenv() function.
	The name of the argument (arg1) should fit decompiled version."

	 ^ self ffiCall: #( String getenv (String arg1) ) module: LibC
]

{ #category : 'environment' }
AbstractUnixPlatform >> environ [
	"Return the address of the array holding the environment variables"

	^ FFIExternalArray fromPointer: (ExternalAddress loadSymbol: 'environ' from: LibC) type: String
]

{ #category : 'environment' }
AbstractUnixPlatform >> environAt: index [

	^ self environ at: index
]

{ #category : 'environment' }
AbstractUnixPlatform >> environmentVariableNamed: aKey ifAbsent: aBlock [
	"See super
	Uses a single encoding determined dynamically"

	^ self at: aKey encoding: self defaultEncoding ifAbsent: aBlock
]

{ #category : 'environment' }
AbstractUnixPlatform >> environmentVariableNamed: aKey put: aValue [
	"See super
	Uses a single encoding determined dynamically"

	^ self at: aKey put: aValue encoding: self defaultEncoding
]

{ #category : 'environment' }
AbstractUnixPlatform >> environmentVariablesDo: aBlock [
	"Do nothing by default"

	
]

{ #category : 'environment' }
AbstractUnixPlatform >> keysAndValuesDo: aBlock [

	| index associationString |
	index := 1.
	[
	associationString := self environAt: index.
	associationString ifNil: [ ^ self ].
	self keysAndValuesDo: aBlock withAssociationString: associationString.
	index := index + 1 ] repeat
]

{ #category : 'environment' }
AbstractUnixPlatform >> rawAt: anEncodedKey ifAbsent: aBlock [
	"Gets the value of an environment variable called `anEncodedKey` that is already encoded (i.e., it is a byte array).
	Execute aBlock if absent.

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	| rawValue |
	rawValue := self basicGetEnvRaw: anEncodedKey asString.
	^ rawValue
		ifNil: [ aBlock value ]
		ifNotNil: [ rawValue asByteArray ]
]

{ #category : 'environment' }
AbstractUnixPlatform >> rawAt: anEncodedKey put: someBytes [
	"Sets the value of an environment variable called `anEncodedKey` to `someBytes`.
	Both arguments should be already encoded (i.e., they are byte arrays).

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	^ self setEnv: anEncodedKey asString value: someBytes asString
]

{ #category : 'environment' }
AbstractUnixPlatform >> rawRemoveKey: anEncodedKey [
	"Removes an environment variable called `anEncodedKey` that is already encoded (i.e., it is a byte array).

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	^ self unsetEnv: anEncodedKey asString
]

{ #category : 'environment' }
AbstractUnixPlatform >> removeEnvironmentVariableNamed: key [
	"See super
	Uses a single encoding determined dynamically"

	^ self removeKey: key encoded: self defaultEncoding
]

{ #category : 'environment' }
AbstractUnixPlatform >> removeKey: key encoded: anEncoding [
	"Removes the entry `aKey` from the environment variables.
	Use `anEncoding` to encode the arguments.

	This is a *nix specific API.
	Rationale: In *nix systems (compared to windows systems) environment variables are stored as raw bytes and can be encoded in different forms."

	^ self rawRemoveKey: (key encodeWith: anEncoding)
]

{ #category : 'environment' }
AbstractUnixPlatform >> setEnv: nameString value: valueString [
	"int setenv(const char *name, const char *value, int overwrite);"

	^ self ffiCall: #( int setenv #( String nameString #, String valueString #, int 1 ) ) module: LibC
]

{ #category : 'environment' }
AbstractUnixPlatform >> unsetEnv: string [
	"This method calls the the platform specific unset environment routine"

	^ self ffiCall: #(int unsetenv #(String string)) module: LibC
]
