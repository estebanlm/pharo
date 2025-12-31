Class {
	#name : 'MetacelloProjectReferenceSpecTestCase',
	#superclass : 'MetacelloSpecTestCase',
	#category : 'Metacello-TestsCore-Specs',
	#package : 'Metacello-TestsCore',
	#tag : 'Specs'
}

{ #category : 'tests' }
MetacelloProjectReferenceSpecTestCase >> testProjectReferenceMergeSpec [

	| projectReferenceA projectReferenceB projectReference project |
	projectReferenceA := MetacelloProjectReferenceSpec projectReference: (self projectSpec
			                      name: 'Project';
			                      className: 'ConfigurationOfProjectA';
			                      yourself).
	projectReferenceB := MetacelloProjectReferenceSpec projectReference: (self projectSpec
			                      name: 'Project';
			                      className: 'ConfigurationOfProjectB';
			                      yourself).
	projectReference := projectReferenceA mergeSpec: projectReferenceB.
	self assert: projectReference name equals: 'Project'.
	self assert: projectReference projectName equals: 'Project'.
	project := projectReference projectReference.
	self assert: project className equals: 'ConfigurationOfProjectB'
]

{ #category : 'tests' }
MetacelloProjectReferenceSpecTestCase >> testProjectReferenceSpec [

	| projectReference project |
	projectReference := MetacelloProjectReferenceSpec projectReference: (project := self projectSpec
			                                name: 'Project';
			                                className: 'ConfigurationOfProjectA';
			                                yourself).
	self assert: projectReference name equals: 'Project'.
	self assert: projectReference projectName equals: 'Project'.
	self assert: projectReference projectReference identicalTo: project.
	self should: [ projectReference includes: #(  ) ] raise: Error.
	self should: [ projectReference requires: #(  ) ] raise: Error.
	projectReference
		projectDo: [ :prjct | self assert: projectReference identicalTo: prjct ]
		packageDo: [ :ignored | self assert: false ]
		groupDo: [ :ignored | self assert: false ]
]
