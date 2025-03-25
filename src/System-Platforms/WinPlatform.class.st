"
I am a an object representing a Windows platform. Use myself to access platform specific features.

Please keep me polymorphic to the the other platform objects.

To get the current platform, you can evaluate:

OSPlatform current.
"
Class {
	#name : 'WinPlatform',
	#superclass : 'OSPlatform',
	#category : 'System-Platforms-Windows',
	#package : 'System-Platforms',
	#tag : 'Windows'
}

{ #category : 'visiting' }
WinPlatform >> accept: aVisitor [

	^ aVisitor visitWindows: self
]

{ #category : 'accessing' }
WinPlatform >> defaultMaximumPathLength [
		"This method returns the default maximum path length for the getCurrentWorkingDirectory implementation. Windows default PATH_MAX is 260.  PATH_MAX is needed to avoid buffer overflow.  In case PATH_MAX is not sufficient the method currentWorkingDirectoryWithBufferSize: can be used to give desired buffer size. The path can include unicode characters, so it can be longer than 260, doubling it should be enough"

	 ^ 260 * 2
]

{ #category : 'environment' }
WinPlatform >> doGetEnvVariable: aVariableName bufferSize: aSize ifAbsent: aBlock isRetry: isRetry [

	| name buffer return lastErrCode |
	name := aVariableName asWin32WideString.
	buffer := Win32WideString new: aSize.

	"This Windows API to get the environment variable has ambiguous behavior when handling environment variables with empty values.
	In the case of a empty string, the API call to get the environment variable returns 0.
	We need to differentiate the 0 in the case of an empty string and when there is an error.
	To do so, we are clearing the last error variable, and also we are retrying.
	The retrying is needed because we can have a race condition between different API calls."

	lastErrCode := self setLastError: 0.
	return := self getEnvironmentVariable: name into: buffer size: aSize + 1.
	lastErrCode := self lastError.

	"From MSDN: If the function fails, the return value is zero. If the specified environment variable was not found in the environment block, GetLastError returns ERROR_ENVVAR_NOT_FOUND."
	return = 0 ifTrue: [
		lastErrCode = 0 ifTrue: [ ^ String new ].
		lastErrCode = 16r000000CB ifTrue: [ ^ aBlock value ]. "ERROR_ENVVAR_NOT_FOUND"

		isRetry
			ifTrue: [ self error: 'Error ' , lastErrCode printString , ' occurred while fetching environment variable ' , aVariableName asString ]
			ifFalse: [
				^ self
					  doGetEnvVariable: aVariableName
					  bufferSize: aSize
					  ifAbsent: aBlock
					  isRetry: true ] ].

	"From MSDN: If lpBuffer is not large enough to hold the data, the return value is the buffer size, in characters,
	required to hold the string and its terminating null character and the contents of lpBuffer are undefined."
	return > aSize ifTrue: [
		^ self
			  doGetEnvVariable: aVariableName
			  bufferSize: return
			  ifAbsent: aBlock
			  isRetry: false ].

	^ buffer asString
]

{ #category : 'environment' }
WinPlatform >> environmentStrings [
	 ^ self ffiCall: #( void * GetEnvironmentStringsW () )
]

{ #category : 'environment' }
WinPlatform >> environmentVariableNamed: aKey ifAbsent: aBlock [
	"The primitive on Windows currently uses the ascii version of the Windows API.
	In such chase try to get value of the environment variable using FFI."

	^ self getEnvVariable: aKey bufferSize: 500 ifAbsent: aBlock
]

{ #category : 'environment' }
WinPlatform >> environmentVariableNamed: aKey put: aValue [
	"The primitive on Windows currently uses the ascii version of the Windows API.
	In such chase try to set the value of the environment variable using FFI."

	| w32Key w32Value return |
	w32Key := aKey asWin32WideString.
	w32Value := aValue asWin32WideString.
	return := self setEnvironmentVariable: w32Key value: w32Value.

	"From MSDN: If the function fails, the return value is zero."
	return = 0 ifTrue: [ self error: 'An error occurred while setting environment variable ' , aKey asString , ' to ' , aValue asString ]
]

{ #category : 'environment' }
WinPlatform >> environmentVariablesDo: aBlock [
	"Under windows the environemtn variables are a single big String."

	"Lines starting with an equal sign are invalid per
	  http://stackoverflow.com/questions/10431689/what-are-these-strange-environment-variables"

	| environmentStrings nextString win32WideString |
	environmentStrings := self environmentStrings.
	[
	win32WideString := Win32WideString fromHandle: environmentStrings.
	nextString := win32WideString asString.
	nextString ifEmpty: [ ^ self ].
	nextString first = $= ifFalse: [ self keysAndValuesDo: aBlock withAssociationString: nextString ].
	environmentStrings := environmentStrings + win32WideString byteSize ] repeat
]

{ #category : 'accessing' }
WinPlatform >> family [
	^#Windows
]

{ #category : 'library path' }
WinPlatform >> ffiLibraryName [

	^ #Kernel32
]

{ #category : 'error handling' }
WinPlatform >> formatMessage: dwFlags _: lpSource _: dwMessageId _: dwLanguageId _: lpBuffer _: nSize _: arguments [

    self ffiCall: #(long FormatMessageW(long   dwFlags,
                            void* lpSource,
                            long   dwMessageId,
                            long   dwLanguageId,
                            void*  lpBuffer,
                            long   nSize,
                            void*  arguments))
]

{ #category : 'environment' }
WinPlatform >> getEnvVariable: aVariableName bufferSize: aSize ifAbsent: aBlock [

	^ self doGetEnvVariable: aVariableName bufferSize: aSize ifAbsent: aBlock isRetry: false
]

{ #category : 'environment-variables' }
WinPlatform >> getEnvironmentVariable: lpName into: lpBuffer size: nSize [
	"Primitive to obtain an environment variable using windows Wide Strings"
	^ self ffiCall: #(ulong GetEnvironmentVariableW (Win32WideString lpName, Win32WideString  lpBuffer, ulong nSize))
]

{ #category : 'error handling' }
WinPlatform >> getErrorMessage: anInteger [

    | buffer |
    buffer := (String new: 500) asWin32WideString.
    self formatMessage: 16r1000 "Format Message From System"
                        _: ExternalAddress null
                        _: anInteger
                        _: 0
                        _: buffer
                        _: 500
                        _: ExternalAddress null.

    ^ buffer asString
]

{ #category : 'file paths' }
WinPlatform >> getTempPath [

  | buffer length |
	length := self defaultMaximumPathLength.
	buffer := (String new: length) asWin32WideString.
	self getTempPath: length buffer: buffer.
	^buffer asString
]

{ #category : 'file paths' }
WinPlatform >> getTempPath: bufferLength buffer: buffer [

    self ffiCall: #(long GetTempPathW(long bufferLength,
                            void*  buffer))
]

{ #category : 'testing' }
WinPlatform >> isWindows [
	^ true
]

{ #category : 'accessing' }
WinPlatform >> keyForValue: aKeyValue [
	^KeyboardKey valueForWindowsPlatform: aKeyValue
]

{ #category : 'accessing' }
WinPlatform >> lastError [

	^ self ffiCall: #(ulong GetLastError())
]

{ #category : 'accessing' }
WinPlatform >> lineEnding [

	^ String crlf
]

{ #category : 'accessing' }
WinPlatform >> menuShortcutString [
	^ 'ctrl'
]

{ #category : 'string-manipulation' }
WinPlatform >> multiByteToWideCharacterCodepage: codepage flags: flags input: input inputLen: inputLen output: output outputLen: outputLen [

	^self ffiCall: #(int MultiByteToWideChar(uint codepage, ulong flags, void* input, int inputLen, Win32WideString output, int outputLen ))
]

{ #category : 'environment' }
WinPlatform >> removeEnvironmentVariable: nameString [

	 ^ self ffiCall: #( int SetEnvironmentVariableW ( Win32WideString nameString, Win32WideString 0 ) )
]

{ #category : 'environment' }
WinPlatform >> removeKey: aKey [
	"The primitive on Windows currently uses the ascii version of the Windows API.
	In such chase try to get value of the environment variable using FFI."

	| return |
	return := self removeEnvironmentVariable: aKey asWin32WideString.

	"From MSDN: If the function fails, the return value is zero."
	return = 0 ifTrue: [
		self error: 'An error occurred while removing environment variable ', aKey asString ]
]

{ #category : 'environment' }
WinPlatform >> setEnv: nameString value: valueString [
	"This method calls the the platform specific set environment routine"

	^ self ffiCall: #( int SetEnvironmentVariableA #( String nameString #, String valueString ) ) module: #Kernel32
]

{ #category : 'environment' }
WinPlatform >> setEnvironmentVariable: nameString value: valueString [

	 ^ self ffiCall: #( int SetEnvironmentVariableW ( Win32WideString nameString, Win32WideString valueString ) )
]

{ #category : 'accessing' }
WinPlatform >> setLastError: aValue [

	^ self ffiCall: #(void SetLastError(ulong aValue))
]

{ #category : 'accessing' }
WinPlatform >> virtualKey: virtualKeyCode [
	"Win32Platform virtualKey: $C charCode"

	(virtualKeyCode between: 65 "$A charCode" and: 90 "$Z")
		ifFalse: [^nil].
	"#($a $b $c $d $e $f $g $h $i $j $k $l $m $n $o $p $q $r $s $t $u $v $w $x $y $z)"

	^(#($a nil $c $d nil $f $g nil nil nil nil $l $m $n nil $p nil nil $s nil nil $v nil $x nil $z)
		at: virtualKeyCode-64) ifNotNil: [:char | char charCode]
]

{ #category : 'string-manipulation' }
WinPlatform >> wideCharacterToMultiByteCodepage: codepage flags: flags input: input inputLen: inputLen output: output outputLen: outputLen [

	^self ffiCall: #(int WideCharToMultiByte(uint codepage, ulong flags, Win32WideString input, int inputLen, void* output, int outputLen, int 0, int 0))
]
