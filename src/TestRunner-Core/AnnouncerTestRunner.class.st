"
I run tests while announcing their execution progress
"
Class {
	#name : 'AnnouncerTestRunner',
	#superclass : 'NewTestRunner',
	#instVars : [
		'job'
	],
	#category : 'TestRunner-Core-Extensions',
	#package : 'TestRunner-Core',
	#tag : 'Extensions'
}

{ #category : 'accessing' }
AnnouncerTestRunner >> job [

	^ job
]

{ #category : 'accessing' }
AnnouncerTestRunner >> job: anObject [

	job := anObject
]

{ #category : 'running' }
AnnouncerTestRunner >> runCase: aTestCase [

	| currentResult |
	self job title: (String streamContents: [ :stream | 
		stream 
			<< 'Running test: ';
			print: aTestCase ] ).
	currentResult := super runCase: aTestCase.
	self job progress: self job progress + (1 / self suite tests size).
	^ currentResult 
]

{ #category : 'running' }
AnnouncerTestRunner >> runSuite [

	^ [ :newJob | 
		self job: newJob.
		super runSuite ] asJob run
]
