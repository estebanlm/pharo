Extension { #name : 'Package' }

{ #category : '*TestRunner-Core' }
Package >> runBy: aTestRunner [

	aTestRunner runPackage: self
]

{ #category : '*TestRunner-Core' }
Package >> suite [

	| suite |
	suite := TestSuite new.
	self definedClasses collect: #suite thenDo: [ :aSuite | suite addTests: aSuite tests ].
	suite name: self name.
	^ suite
]
