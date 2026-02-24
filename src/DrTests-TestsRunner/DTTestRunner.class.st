Class {
	#name : 'DTTestRunner',
	#superclass : 'Object',
	#instVars : [
		'plugin'
	],
	#category : 'DrTests-TestsRunner',
	#package : 'DrTests-TestsRunner'
}

{ #category : 'initialization' }
DTTestRunner class >> plugin: aPlugin [

	^ self new plugin: aPlugin; yourself
]

{ #category : 'accessing' }
DTTestRunner >> plugin [

	^ plugin
]

{ #category : 'accessing' }
DTTestRunner >> plugin: anObject [

	plugin := anObject
]

{ #category : 'api' }
DTTestRunner >> runSuite: aTestSuite withResult: aResult [

	aTestSuite when: TestAnnouncement do: [ :testAnnouncement |
		self flag: #TODO. "Dirty"
		testAnnouncement test class = TestSuite ifTrue: [
			self plugin announceStatusChanged:
				('Running test {1}.' format: { testAnnouncement test name }) ] ]
		for: self.
	[ aResult mergeWith: (aTestSuite run) ] ensure: [
		aTestSuite unsubscribe: TestAnnouncement ]
]

{ #category : 'api' }
DTTestRunner >> runTestSuite: testSuite [

	| result |
	result := TestAsserter classForTestResult new.
	CurrentExecutionEnvironment runTestsBy: [
				| specificResult |
				specificResult := testSuite resultClass new.
				self runSuite: testSuite withResult: specificResult.
				result mergeWith: specificResult ].
	result updateResultsInHistory.
	^ result
]

{ #category : 'api' }
DTTestRunner >> runTestSuites: testSuites [

	| result |
	result := TestAsserter classForTestResult new.
	CurrentExecutionEnvironment runTestsBy: [
		testSuites
			do: [ :testSuite |
				| specificResult |
				specificResult := testSuite resultClass new.
				self runSuite: testSuite withResult: specificResult.
				result mergeWith: specificResult ]
			displayingProgress: 'Running Tests' ].
	result updateResultsInHistory.
	^ result
]
