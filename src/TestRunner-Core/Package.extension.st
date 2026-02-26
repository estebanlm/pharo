Extension { #name : 'Package' }

{ #category : '*TestRunner-Core' }
Package >> runBy: aTestRunner [

	aTestRunner runPackage: self
]

{ #category : '*TestRunner-Core' }
Package >> suite [

	^ TestSuite
]
