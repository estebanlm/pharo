Class {
	#name : 'SessionManagerTest',
	#superclass : 'TestCase',
	#category : 'System-SessionManager-Tests',
	#package : 'System-SessionManager-Tests'
}

{ #category : 'tests' }
SessionManagerTest >> testStartUpList [
	"This test documents issue http://code.google.com/p/pharo/issues/detail?id=838"

	| startupList |
	startupList := SessionManager default startupList collect: [ :each | each handlerId ].
	self assert: (startupList indexOf: #Delay) < (startupList indexOf: #GlobalIdentifier)
]
