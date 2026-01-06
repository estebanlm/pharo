Class {
	#name : 'ScopedSelector',
	#superclass : 'Object',
	#instVars : [
		'symbol',
		'owner'
	],
	#category : 'Kernel-CodeModel-Packages',
	#package : 'Kernel-CodeModel',
	#tag : 'Packages'
}

{ #category : 'converting' }
ScopedSelector >> asSelector [
	
	^ self
]

{ #category : 'converting' }
ScopedSelector >> asString [

	^ self symbol asString
]

{ #category : 'matching' }
ScopedSelector >> beginsWith: aString [ 
	
	^ self asString beginsWith: aString
]

{ #category : 'private' }
ScopedSelector >> flushCache [
	"Tell the virtual machine to remove all entries with this symbol as a selector from its method lookup caches, if it has any.  This 	must be done whenever a method is added, redefined or removed, so that message lookups reflect the revised organization.  c.f. 	Behavior>>flushCache & CompiledMethod>>flushCache.  Essential. See MethodDictionary class comment."

	<primitive: 119>
]

{ #category : 'accessing' }
ScopedSelector >> handleDoesNotUnderstand: aMessage to: aReceiver [

	| aliasedMethod |
	"Lookup failed on a scoped send to a non-extended class.
	We should lookup a non extension method, and activate it."
	
	aliasedMethod := aMessage lookupClass lookupSelector: aMessage selector symbol.	
	aliasedMethod methodClass methodDict at: aMessage selector put: aliasedMethod.

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
