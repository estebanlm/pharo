Class {
	#name : 'MetacelloVersionNumberTestCase',
	#superclass : 'TestCase',
	#category : 'Metacello-TestsCore',
	#package : 'Metacello-TestsCore'
}

{ #category : 'tests - alpha/numeric version numbers' }
MetacelloVersionNumberTestCase >> testAlphaNumericVersion1 [

	"Use numeric comparison for pure numbers. If you non-numeric version separate with '-'"
	
	| x y |
	self assert: ((x := self versionClass fromString: '2.9.0') < (y := self versionClass fromString: '2.10.0')).
]

{ #category : 'tests - alpha/numeric version numbers' }
MetacelloVersionNumberTestCase >> testAlphaNumericVersion2 [

	self assert: ((self versionClass fromString: '2.9.0-alpha.2') < (self versionClass fromString: '2.9.0-alpha.3')).
]

{ #category : 'tests - alpha/numeric version numbers' }
MetacelloVersionNumberTestCase >> testAlphaNumericVersion3 [

	self assert: ((self versionClass fromString: '2.9.9-alpha.2') < (self versionClass fromString: '2.9.10')).
]

{ #category : 'tests - alpha/numeric version numbers' }
MetacelloVersionNumberTestCase >> testAlphaNumericVersion4 [

	self assert: ((self versionClass fromString: '2.9.9-alpha.2') < (self versionClass fromString: '2.9.9')).
]

{ #category : 'tests - approximately greater than' }
MetacelloVersionNumberTestCase >> testApproxVersion01 [

	self assert: '1.1.1' asMetacelloVersionNumber ~> '1.1' asMetacelloVersionNumber
]

{ #category : 'tests - approximately greater than' }
MetacelloVersionNumberTestCase >> testApproxVersion02 [

	self deny: '1.1' asMetacelloVersionNumber ~> '1' asMetacelloVersionNumber
]

{ #category : 'tests - approximately greater than' }
MetacelloVersionNumberTestCase >> testApproxVersion03 [

	self assert: '1.1' asMetacelloVersionNumber ~> '1.1' asMetacelloVersionNumber
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testCollapseZeros [
	self assert: (MetacelloVersionNumber fromString: '1.0-beta.24.0.1') collapseZeros printString equals: '1-beta.24.0.1'.
	self assert: (MetacelloVersionNumber fromString: '1.0-beta.24.0.0.1') collapseZeros printString equals: '1-beta.24.0.0.1'.
	self assert: (MetacelloVersionNumber fromString: '1.0.0-beta.24.0.0.1') collapseZeros printString equals: '1-beta.24.0.0.1'
]

{ #category : 'tests - matching' }
MetacelloVersionNumberTestCase >> testInvalidSpecialMatch [

	self 
		should: [ ((self versionClass fromString: '1.1') match: '?.?') ]
		raise: Error.
]

{ #category : 'tests - matching' }
MetacelloVersionNumberTestCase >> testSpecialMatch [

	self assert: ((self versionClass fromString: '1.1') match: '?').
	self assert: ((self versionClass fromString: 'alpha') match: '?').
	self assert: ((self versionClass fromString: '1.1.1.1.1') match: '?').
	self assert: ((self versionClass fromString: '1.alpha5') match: '?').
	self assert: ((self versionClass fromString: '1.1') match: '*.?').
	self assert: ((self versionClass fromString: '1.1') match: '?').
	self assert: ((self versionClass fromString: '10.1.1.1.1') match: '?').
	self deny: ((self versionClass fromString: '1.1') match: '*.*.?').
	self assert: ((self versionClass fromString: '1.1.1') match: '*.?').
]

{ #category : 'tests - matching' }
MetacelloVersionNumberTestCase >> testStandardMatch [

	self assert: ((self versionClass fromString: '1.1.1') match: '*.*.*').
	self deny: ((self versionClass fromString: '1.1.1') match: '*.*').
	self assert: ((self versionClass fromString: '1.1.0') match: '1.1.*').
	self assert: ((self versionClass fromString: '1.1.0') match: '1.#.*').
	self deny: ((self versionClass fromString: '1.10.0') match: '1.#.*').
	self assert: ((self versionClass fromString: '1-alpha5.0') match: '1-alpha#.0').
	self assert: ((self versionClass fromString: '1.alpha5.0') match: '1-alpha#.0').
	self assert: ((self versionClass fromString: '1.alpha5.0') match: '1.alpha#.0').
	self deny: ((self versionClass fromString: '1-alpha10.0') match: '1-alpha#.0').
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion01 [
	self assert: (self versionClass fromString: '1.1.1') versionString equals: '1.1.1'
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion02 [
	| v1 v2 |
	v1 := self versionClass fromString: '1.1.1'.
	v2 := self versionClass fromString: '1.0.0'.
	self assert: v1 equals: v1.
	self assert: v2 equals: v2.
	self assert: v1 > v2
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion03 [

	| v1 v2 |
	v1 := self versionClass fromString: '1.0.0.1'.
	v2 := self versionClass fromString: '1.0.0'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion04 [

	| v1 v2 |
	v1 := self versionClass fromString: '1.0.1'.
	v2 := self versionClass fromString: '1.0.0'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion05 [

	| v1 v2 |
	v1 := self versionClass fromString: '3'.
	v2 := self versionClass fromString: '2'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion06 [

	| v1 v2 |
	v1 := self versionClass fromString: '3.'.
	v2 := self versionClass fromString: '2'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion07 [

	| v1 v2 |
	v1 := self versionClass fromString: '3.0.0'.
	v2 := self versionClass fromString: '2'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion08 [

	| v1 v2 |
	v1 := self versionClass fromString: '1.0a6'.
	v2 := self versionClass fromString: '1.0a5'.
	self assert: (v1 > v2)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion09 [

	| v1 v2 |
	v1 := self versionClass fromString: '1.0'.
	v2 := self versionClass fromString: '0.7'.
	self assert: (v1 >= v2).
	self assert: (v2 <= v1)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion10 [
	| x y |
	self
		assert:
			(x := (({(self versionClass fromString: '1.0') . (self versionClass fromString: '0.7') . (self versionClass fromString: '0.8').
			(self versionClass fromString: '0.9') . (self versionClass fromString: '1.0.1')} sort: [ :a :b | a <= b ]) collect: [ :each | each versionString ]) asArray)
		equals: (y := #('0.7' '0.8' '0.9' '1.0' '1.0.1'))
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion11 [

	| v1 v2 |
	v1 := self versionClass fromString: '1.0.1b'.
	v2 := self versionClass fromString: '1.0.1a'.
	self assert: (v1 >= v2).
	self assert: (v2 <= v1)
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion12 [

	self deny: ((self versionClass fromString: '1.0') <= (self versionClass fromString: '0.7'))
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion13 [

	self deny: ((self versionClass fromString: '0.8') <= (self versionClass fromString: '0.7')).
	self deny: ((self versionClass fromString: '0.8.1.8') <= (self versionClass fromString: '0.7.0.5')).
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion14 [

	self assert: ((self versionClass fromString: '2.9.0-alpha02') < (self versionClass fromString: '2.9.0-alpha03')).
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion15 [

	self assert: ((self versionClass fromString: '1.0-beta.0') < (self versionClass fromString: '1.0-beta.1')).
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion16 [
    self assert: (self versionClass fromString: '1.0-beta.0') < (self versionClass fromString: '1.0').
    self assert: (self versionClass fromString: '1.0-beta.0') < (self versionClass fromString: '1.0.0').
    self assert: (self versionClass fromString: '1.0-beta.0') < (self versionClass fromString: '1.0.0.0')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion17 [
	self assert: (self versionClass fromString: '1.0') equals: (self versionClass fromString: '1.0.0').
	self assert: (self versionClass fromString: '1') equals: (self versionClass fromString: '1.0').
	self assert: (self versionClass fromString: '1') > (self versionClass fromString: '1-0').
	self assert: (self versionClass fromString: '1') > (self versionClass fromString: '1.0-beta.0').
	self assert: (self versionClass fromString: '1') > (self versionClass fromString: '1-beta.0').
	self assert: (self versionClass fromString: '1') > (self versionClass fromString: '1-beta')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion18 [

	self deny: ((self versionClass fromString: '1.0') < (self versionClass fromString: '1')).
	self deny: ((self versionClass fromString: '1.0') < (self versionClass fromString: '1-0')).
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion19 [

	self assert: ((self versionClass fromString: '1.0-beta.0') < (self versionClass fromString: '1')).
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion20 [
	self assert: (MetacelloVersionNumber fromString: '') printString equals: ''
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion21 [
	self deny: (MetacelloVersionNumber fromString: '') > (MetacelloVersionNumber fromString: '0').
	self assert: (MetacelloVersionNumber fromString: '') < (MetacelloVersionNumber fromString: '0').
	self assert: (MetacelloVersionNumber fromString: '') equals: (MetacelloVersionNumber fromString: '')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion22 [
	self assert: (MetacelloVersionNumber fromString: '3.0.0') collapseZeros size equals: 1.
	self assert: (MetacelloVersionNumber fromString: '3.0.0') equals: (MetacelloVersionNumber fromString: '3.0').
	self assert: (MetacelloVersionNumber fromString: '3.0') equals: (MetacelloVersionNumber fromString: '3.0.0')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion23 [
	self assert: (MetacelloVersionNumber fromString: '3.0.0.-rc.1') equals: (MetacelloVersionNumber fromString: '3.0.0-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3.0') > (MetacelloVersionNumber fromString: '3.0-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3') > (MetacelloVersionNumber fromString: '3-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3.-rc.1') equals: (MetacelloVersionNumber fromString: '3.0.0-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3.0.-rc.1') equals: (MetacelloVersionNumber fromString: '3.0.0-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3') > (MetacelloVersionNumber fromString: '3.0-rc.1').
	self assert: (MetacelloVersionNumber fromString: '3.0') > (MetacelloVersionNumber fromString: '3.0.0-rc.1')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion24 [
	self assert: (MetacelloVersionNumber fromString: '3.0.3.-rc.1') ~= (MetacelloVersionNumber fromString: '3.0.0.3-rc.1').
	self assert: (MetacelloVersionNumber fromString: '1.0.0.1.0.0') equals: (MetacelloVersionNumber fromString: '1.0.0.1').
	self assert: (MetacelloVersionNumber fromString: '1.0.0.1') ~= (MetacelloVersionNumber fromString: '1..1')
]

{ #category : 'tests' }
MetacelloVersionNumberTestCase >> testVersion25 [

	self assert: ((MetacelloVersionNumber fromString: '1.0-beta.24.0.1') < (MetacelloVersionNumber fromString: '1.0-beta.28')).
]

{ #category : 'private' }
MetacelloVersionNumberTestCase >> versionClass [

	^MetacelloVersionNumber
]
