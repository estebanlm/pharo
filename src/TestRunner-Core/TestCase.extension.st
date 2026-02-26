Extension { #name : 'TestCase' }

{ #category : '*TestRunner-Core' }
TestCase >> runBy: aTestRunner [

	aTestRunner runCase: self
]

{ #category : '*TestRunner-Core' }
TestCase >> suite [

	^ (TestSuite named: self selector ) addTest: self; yourself
]
