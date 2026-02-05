Class {
	#name : 'DependencyTest',
	#superclass : 'MockTest',
	#classInstVars : [
		'data'
	],
	#category : 'TestRunner-FakeTests',
	#package : 'TestRunner-FakeTests'
}

{ #category : 'initialization' }
DependencyTest class >> data [

	^ data
]

{ #category : 'initialization' }
DependencyTest class >> data: anInteger [

	data := anInteger
]

{ #category : 'initialization' }
DependencyTest class >> incrementData [
	data add: 1
]

{ #category : 'class initialization' }
DependencyTest class >> reset [

	<script>
	data := OrderedCollection new
]

{ #category : 'initialization' }
DependencyTest >> assertCountThenIncrement: anObject [

	self skipOnPharoCITestingEnvironment.
	self ignore.
	self assert: self count equals: anObject .
	self class incrementData
]

{ #category : 'accessing' }
DependencyTest >> count [

	^ self class data size
]

{ #category : 'script' }
DependencyTest >> resetData [
	<script>
	self class reset
]

{ #category : 'initialization' }
DependencyTest >> testDataIs10ThenIncrement [

	self 
		resetData;
		assertCountThenIncrement: 0
]

{ #category : 'initialization' }
DependencyTest >> testDataIs11ThenIncrement [

	self assertCountThenIncrement: 1
]

{ #category : 'initialization' }
DependencyTest >> testDataIs12ThenIncrement [

	self assertCountThenIncrement: 2
]

{ #category : 'initialization' }
DependencyTest >> testDataIs13ThenIncrement [

	self assertCountThenIncrement: 3
]

{ #category : 'initialization' }
DependencyTest >> testDataIs14ThenIncrement [

	self assertCountThenIncrement: 4
]

{ #category : 'initialization' }
DependencyTest >> testDataIs15ThenIncrement [

	self assertCountThenIncrement: 5
]
