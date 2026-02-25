Class {
	#name : 'TestAnnouncerDecorator',
	#superclass : 'NewTestRunner',
	#instVars : [
		'job'
	],
	#category : 'TestRunner-Core-Core',
	#package : 'TestRunner-Core',
	#tag : 'Core'
}

{ #category : 'accessing' }
TestAnnouncerDecorator >> job [

	^ job
]

{ #category : 'accessing' }
TestAnnouncerDecorator >> job: anObject [

	job := anObject
]

{ #category : 'running' }
TestAnnouncerDecorator >> runCase: aTestCase [

	self job title: (String streamContents: [ :stream | 
		stream 
			<< 'Running test: ';
			print: aTestCase ]).
	super runCase: aTestCase.
	self job progress: self job progress + (1 / self suite tests size).
]

{ #category : 'running' }
TestAnnouncerDecorator >> runSuite [

	^ [ :newJob | 
		self job: newJob.
		super runSuite ] asJob run
]
