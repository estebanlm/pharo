"
I run tests while announcing their execution progress. I was meant to be a decorator for `ExecutionMode`.
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
	self job title: 'Running test: ', aTestCase asString.
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
