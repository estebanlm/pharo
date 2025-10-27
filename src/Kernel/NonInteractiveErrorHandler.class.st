Class {
	#name : 'NonInteractiveErrorHandler',
	#superclass : 'ErrorHandler',
	#instVars : [
		'doNotQuitOnRestart'
	],
	#classVars : [
		'SnapshotErrorImage'
	],
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'testing' }
NonInteractiveErrorHandler class >> isValidForCurrentSystemConfiguration [

	^ Smalltalk isInteractive not
]

{ #category : 'accessing' }
NonInteractiveErrorHandler class >> snapshotErrorImage [
	^ SnapshotErrorImage == true
]

{ #category : 'accessing' }
NonInteractiveErrorHandler class >> snapshotErrorImage: aBoolean [
	SnapshotErrorImage := aBoolean
]

{ #category : 'events' }
NonInteractiveErrorHandler >> exitFailure [
	[
		self class snapshotErrorImage ifTrue: [
			doNotQuitOnRestart := true.
			"make a new image version snapshot before leaving"
			Smalltalk saveAsNewVersion  ].
	] ensure: [
		doNotQuitOnRestart ifFalse: [ Smalltalk exitFailure ].
		doNotQuitOnRestart := false.
	]
]

{ #category : 'initialization' }
NonInteractiveErrorHandler >> initialize [
	doNotQuitOnRestart := false
]

{ #category : 'events' }
NonInteractiveErrorHandler >> quitFrom: aContext withMessage: aString [

	" log error and quit "
	[ Smalltalk
		logError: aString
		inContext: aContext.

	" Print stacks of all current processes "

	Smalltalk logDuring: [:logger |
		logger nextPutAll: 'Processes and their stacks: ';cr.

		Process allInstances do: [:each | | ctx |
			logger nextPutAll: 'Process: '; print: each; cr; nextPutAll: '  stack:'; cr; cr.

			ctx := each isActive ifTrue: [ thisContext sender ] ifFalse: [ each suspendedContext ].
			ctx ifNotNil: [
				(ctx stackOfSize: 20) do: [:s | logger print: s; cr ]].
			logger nextPutAll: '------------------------------'; cr; cr.
		]].
	] ensure: [ self exitFailure ]
]
