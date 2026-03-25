Class {
	#name : 'OCTraitMethodInstaller',
	#superclass : 'OCAnnouncingMethodInstaller',
	#category : 'OpalCompiler-Core-FrontEnd',
	#package : 'OpalCompiler-Core',
	#tag : 'FrontEnd'
}

{ #category : 'installing' }
OCTraitMethodInstaller >> addAndClassifySelector: selector withMethod: compiledMethod into: behavior inProtocol: aProtocol [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"

	<reflection: 'Class structural modification - Selector/Method modification'>
	behavior localMethodDict at: selector put: compiledMethod.

	super
		addAndClassifySelector: selector
		withMethod: compiledMethod
		into: behavior
		inProtocol: aProtocol.

	TraitChange addSelector: selector on: behavior
]
