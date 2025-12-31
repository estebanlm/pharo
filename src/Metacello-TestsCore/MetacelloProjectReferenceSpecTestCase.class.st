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
	projectReferenceA := self projectReferenceSpec
		                     projectReference: (self projectSpec
				                      name: 'Project';
				                      className: 'ConfigurationOfProjectA';
				                      yourself);
		                     yourself.
	projectReferenceB := self projectReferenceSpec
		                     projectReference: (self projectSpec
				                      name: 'Project';
				                      className: 'ConfigurationOfProjectB';
				                      yourself);
		                     yourself.
	projectReference := projectReferenceA mergeSpec: projectReferenceB.
	self assert: projectReference name equals: 'Project'.
	self assert: projectReference projectName equals: 'Project'.
	project := projectReference projectReference.
	self assert: project className equals: 'ConfigurationOfProjectB'
]

{ #category : 'tests' }
MetacelloProjectReferenceSpecTestCase >> testProjectReferenceSpec [

	| projectReference project |
	projectReference := self projectReferenceSpec
		                    projectReference: (project := self projectSpec
				                                name: 'Project';
				                                className: 'ConfigurationOfProjectA';
				                                yourself);
		                    yourself.
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
