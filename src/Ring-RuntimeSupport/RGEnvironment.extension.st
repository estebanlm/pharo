Extension { #name : 'RGEnvironment' }

{ #category : '*Ring-RuntimeSupport' }
RGEnvironment >> addGlobalsNamed: anArrayOfSymbols [

	anArrayOfSymbols do: [ :each |
		self addGlobalVariable: (RGGlobalVariable named: each parent: self)]
]
