Class {
	#name : 'OCExtensionMethodInstaller',
	#superclass : 'OCAnnouncingMethodInstaller',
	#instVars : [
		'shouldRecompileDependencies'
	],
	#category : 'Kernel-CodeModel-Methods',
	#package : 'Kernel-CodeModel',
	#tag : 'Methods'
}

{ #category : 'accessing' }
OCExtensionMethodInstaller >> initialize [

	super initialize.
	shouldRecompileDependencies := false
]

{ #category : 'installing' }
OCExtensionMethodInstaller >> install: method into: extension compiler: compiler [

	| scopedSelector visibleExtensions methodCopyInExtendedClass selectorSymbol packagesToRecompile |
	super install: method into: extension compiler: compiler.

	scopedSelector := method selector.
	selectorSymbol := scopedSelector symbol. "If the extension overwrites a normal method, then install a conflict method"
	visibleExtensions := scopedSelector extensionsOn: extension extendedClass.
	methodCopyInExtendedClass := (extension extendedClass methodDictionary includesKey: selectorSymbol)
		                             ifTrue: [
				                             ConflictMethod new
					                             overwrittenSelector: selectorSymbol;
					                             conflictingClass: extension extendedClass;
					                             conflictingExtensions: visibleExtensions;
					                             yourself ]
		                             ifFalse: [
				                             visibleExtensions size > 1
					                             ifTrue: [
							                             ConflictMethod new
								                             overwrittenSelector: selectorSymbol;
								                             conflictingClass: extension extendedClass;
								                             conflictingExtensions: visibleExtensions;
								                             yourself ]
					                             ifFalse: [
							                             method copy
								                             methodClass: extension extendedClass;
								                             yourself ] ]. "We install the extension in the extended class"
	methodCopyInExtendedClass propertyAt: #extensionPackage put: extension package.
	extension extendedClass classify: scopedSelector under: protocol.
	extension extendedClass methodDict at: scopedSelector put: methodCopyInExtendedClass.
	scopedSelector addExtendedBehavior: extension extendedClass. "Alias subclasses"
	scopedSelector bindAliasesInSubclassesOf: extension extendedClass. "Update user packages so they define a locally scoped selector with the same name"
	extension hasUserPackages ifTrue: [ extension userPackages do: [ :e | e internScopedSelector: selectorSymbol ] ].

	shouldRecompileDependencies ifFalse: [ ^ self ].
	packagesToRecompile := { extension package }.
	extension hasUserPackages ifTrue: [ packagesToRecompile := packagesToRecompile , extension userPackages asArray ].
	(packagesToRecompile flatCollect: [ :p | p methods ]) do: [ :m |
			m methodClass compile: m sourceCode notifying: nil methodInstaller: (m methodClass methodInstaller
					 logged: false;
					 changeStamp: changeStamp;
					 protocol: m protocol) ]
]

{ #category : 'accessing' }
OCExtensionMethodInstaller >> shouldRecompileDependencies [

	^ shouldRecompileDependencies
]

{ #category : 'accessing' }
OCExtensionMethodInstaller >> shouldRecompileDependencies: anObject [

	shouldRecompileDependencies := anObject
]
