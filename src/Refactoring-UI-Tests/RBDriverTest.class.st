Class {
	#name : 'RBDriverTest',
	#superclass : 'ReDriverTest',
	#category : 'Refactoring-UI-Tests',
	#package : 'Refactoring-UI-Tests'
}

{ #category : 'tests' }
RBDriverTest >> testAllDriversHaveADisplayString [

	self shouldnt: [ ReInteractionDriver drivers collect: [ :driver | driver menuItemString ] ] raise: Error.
	ReInteractionDriver drivers collect: [ :driver |
			self assert: driver menuItemString isString.
			self assert: driver menuItemString isNotEmpty ]
]
