Class {
	#name : 'ScopedSelector',
	#superclass : 'Object',
	#instVars : [
		'symbol',
		'owner',
		'extendedBehaviors'
	],
	#category : 'Kernel-CodeModel-Packages',
	#package : 'Kernel-CodeModel',
	#tag : 'Packages'
}

{ #category : 'accessing' }
ScopedSelector >> addExtendedBehavior: aBehavior [

	extendedBehaviors ifNil: [ extendedBehaviors := Set new ].
	extendedBehaviors	add: aBehavior
]

{ #category : 'converting' }
ScopedSelector >> asSelector [
	
	^ self
]

{ #category : 'converting' }
ScopedSelector >> asString [

	^ self symbol asString
]

{ #category : 'converting' }
ScopedSelector >> asSymbol [
	
	^ self symbol
]

{ #category : 'matching' }
ScopedSelector >> beginsWith: aString [ 
	
	^ self asString beginsWith: aString
]

{ #category : 'as yet unclassified' }
ScopedSelector >> cleanupExtendedBehaviors [

	extendedBehaviors ifNil: [ ^ self ].
	extendedBehaviors do: [ :e | e methodDict removeKey: self ].
	extendedBehaviors := nil
]

{ #category : 'accessing' }
ScopedSelector >> extendedBehaviors [
	
	^ extendedBehaviors ifNil: [#()]
]

{ #category : 'private' }
ScopedSelector >> flushCache [
	"Tell the virtual machine to remove all entries with this symbol as a selector from its method lookup caches, if it has any.  This 	must be done whenever a method is added, redefined or removed, so that message lookups reflect the revised organization.  c.f. 	Behavior>>flushCache & CompiledMethod>>flushCache.  Essential. See MethodDictionary class comment."

	<primitive: 119>
]

{ #category : 'accessing' }
ScopedSelector >> handleDoesNotUnderstand: aMessage to: aReceiver [

	| aliasedMethodLookupResult aliasedMethod aliasedMethodOwner |
	"Lookup failed on a scoped send to a non-extended class.
	We should lookup an aliased method, and activate it."
	
	aliasedMethodLookupResult := self lookupAliasedMethodOnReceiverClass: aReceiver class lookupClass: aMessage lookupClass.
	
	"If this is a real DNU, redispatch the DNU using the symbol"
	aliasedMethodLookupResult ifNil: [
		^ aMessage selector symbol handleDoesNotUnderstand: aMessage to: aReceiver ].
	
	aliasedMethodOwner := aliasedMethodLookupResult first.
	aliasedMethod := aliasedMethodLookupResult second.
	self addExtendedBehavior: aliasedMethodOwner.
	aliasedMethodOwner methodDict at: aMessage selector put: aliasedMethod.

	^ aMessage sentTo: aReceiver
]

{ #category : 'converting' }
ScopedSelector >> isBinary [

	^ self symbol isBinary
]

{ #category : 'testing' }
ScopedSelector >> isDoIt [
	
	^ self symbol isDoIt
]

{ #category : 'testing' }
ScopedSelector >> isScopedSelector [

	^ true
]

{ #category : 'accessing' }
ScopedSelector >> keywords [

	^ symbol keywords
]

{ #category : 'accessing' }
ScopedSelector >> lookupAliasedMethodOnReceiverClass: aClass [
	
	^ self lookupAliasedMethodOnReceiverClass: aClass lookupClass: nil
]

{ #category : 'accessing' }
ScopedSelector >> lookupAliasedMethodOnReceiverClass: aClass lookupClass: lookupClass [

	| theLookupClass foundMethod |
	"I'm looking for aliases: methods that we imported or are global.
	Let's look up recursively starting at aClass/lookupClass"
	theLookupClass := lookupClass ifNil: [ aClass ].


	[ theLookupClass notNil ] whileTrue: [
		| allVisibleExtensions |
		allVisibleExtensions := (owner definedClasses select: [ :e | e isKindOf: Extension ]) , owner importedExtensions.
		allVisibleExtensions do: [ :e |
			"Shouldn't we lookup in the hierarchy from theLookupClass up to Object?"
				e extendedClass == theLookupClass ifTrue: [
						^ {
							  e extendedClass.
							  (e lookupSelector: (e package lookupSelector: self symbol)) } ] ].
		
		theLookupClass := theLookupClass superclass ].
		
	"We reached the top of the hierarchy and found no extensions, just look for the symbol"
	foundMethod := (lookupClass ifNil: [ aClass ]) lookupSelector: self symbol.
	foundMethod ifNil: [ ^ nil ].
	^ {
		  foundMethod methodClass.
		  foundMethod }
]

{ #category : 'accessing' }
ScopedSelector >> numArgs [
	
	^ self symbol numArgs
]

{ #category : 'accessing' }
ScopedSelector >> owner [

	^ owner
]

{ #category : 'accessing' }
ScopedSelector >> owner: anObject [

	owner := anObject
]

{ #category : 'printing' }
ScopedSelector >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: symbol;
		nextPutAll: ' - ';
		print: owner name;
		nextPutAll: ')'
]

{ #category : 'accessing' }
ScopedSelector >> symbol [

	^ symbol
]

{ #category : 'accessing' }
ScopedSelector >> symbol: anObject [

	symbol := anObject
]
