Class {
	#name : 'RePackageConditionsTest',
	#superclass : 'TestCase',
	#category : 'Refactoring-Core-Tests-Conditions',
	#package : 'Refactoring-Core-Tests',
	#tag : 'Conditions'
}

{ #category : 'tests' }
RePackageConditionsTest >> testNamesAreDifferent [
    | condition |
    condition := RePackageNamesAreDifferentCondition new
        packageName: #'PackageA';
        newName: #'PackageB';
        yourself.
    self assert: condition check.
    self assert: condition violators isEmpty.
]

{ #category : 'tests' }
RePackageConditionsTest >> testNamesAreSame [
    | condition |
    condition := RePackageNamesAreDifferentCondition new
        packageName: #'PackageA';
        newName: #'PackageA';
        yourself.
    self deny: condition check.
    self assert: condition violators isNotEmpty.
]

{ #category : 'tests' }
RePackageConditionsTest >> testPackageDoesNotExist [
    | condition organizer |
    organizer := self packageOrganizer.
    condition := RePackageExistsCondition new
        packageName: #'PackageNotExist';
        packageOrganizer: organizer.
    self deny: condition check.
    self assert: condition violators isNotEmpty.
]

{ #category : 'tests' }
RePackageConditionsTest >> testPackageExists [
    | condition organizer |
    organizer := self packageOrganizer.
    condition := RePackageExistsCondition new
        packageName: #'Refactoring-Core';
        packageOrganizer: organizer;
        yourself.
    self assert: condition check.
    self assert: condition violators isEmpty.
]
