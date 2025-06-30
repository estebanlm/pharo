Class {
	#name : 'CoSinglePackageScopedGlobalVariableFetcherAlternateTest',
	#superclass : 'CoMiniTestCase',
	#instVars : [
		'ai12',
		'ai13',
		'a11',
		'aa1',
		'ai2',
		'ai23',
		'aa2',
		'ai3',
		'a33',
		'blop',
		'aiGlobal1',
		'aiGlobal2',
		'package1',
		'package2',
		'package3',
		'organizer'
	],
	#category : 'HeuristicCompletion-Tests-Core',
	#package : 'HeuristicCompletion-Tests',
	#tag : 'Core'
}

{ #category : 'two locals one global' }
CoSinglePackageScopedGlobalVariableFetcherAlternateTest >> testFirstPackageLevelWithTwoClasses [

	| fetchedElements |
	fetchedElements := self fetcher next: 3.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expectedElements at: index) ].
	self assert: fetchedElements size equals: 2
]

{ #category : 'one local one global' }
CoSinglePackageScopedGlobalVariableFetcherAlternateTest >> testFirstPackageOfCompletionClass [

	| fetchedElements expected |
	fetchedElements := self fetcher next: 2.
	expected := { self firstExpectedElement . self secondExpectedElement }.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: 2
]

{ #category : 'one local one global' }
CoSinglePackageScopedGlobalVariableFetcherAlternateTest >> testResetShouldRestartGenerator [

	| fetchedElements |
	
	self fetcher upToEnd; reset.
	fetchedElements := self fetcher next: expectedElements size + 1.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expectedElements at: index) ].
	self assert: fetchedElements size equals: 2
]
