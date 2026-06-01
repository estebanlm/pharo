Class {
	#name : 'TestResultTest',
	#superclass : 'TestCase',
	#category : 'SUnit-Tests-Core',
	#package : 'SUnit-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
TestResultTest >> testDebugFiresNotificationBeforeAndAfter [

	| unitTestClass historyAnnouncements |
	unitTestClass := ClassFactoryForTestCaseTest.
	unitTestClass resetAnnouncer.
	unitTestClass resetHistory.

	unitTestClass compile: 'testFailing self assert: false'.


	historyAnnouncements := OrderedCollection new.
	unitTestClass historyAnnouncer when: TestSuiteEnded do: [ :announcement | historyAnnouncements add: announcement ] for: self.
	[ unitTestClass debug: #testFailing ]
		on: Exception
		do: [ :ex | self assert: historyAnnouncements isNotEmpty ].

	self assert: historyAnnouncements size equals: 2.

	unitTestClass historyAnnouncer unsubscribe: self.
	unitTestClass resetHistory.
	unitTestClass removeSelector: #testFailing
]

{ #category : 'tests' }
TestResultTest >> testRemoveFromTestHistoryFiresHistoryAnnouncement [
	"Removing a method from test history should announce TestSuiteEnded
     on the class historyAnnouncer so the class-level bubble turns grey."

	| unitTest announcements selector |
	unitTest := ClassFactoryForTestCaseTest.
	unitTest resetAnnouncer.
	unitTest resetHistory.
	unitTest suite run.
	selector := (unitTest history at: #passed) anyOne.

	announcements := OrderedCollection new.
	unitTest historyAnnouncer when: TestSuiteEnded do: [ :ann | announcements add: ann ] for: self.
	TestResult removeFromTestHistory: selector in: unitTest.
	self deny: ((unitTest history at: #passed) includes: selector).
	self assert: announcements size equals: 1.
	self assert: (announcements first isKindOf: TestSuiteEnded).
	unitTest historyAnnouncer unsubscribe: self.
	unitTest resetHistory
]
