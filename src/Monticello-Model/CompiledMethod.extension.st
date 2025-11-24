Extension { #name : 'CompiledMethod' }

{ #category : '*Monticello-Model' }
CompiledMethod >> asMCMethodDefinition [
	"Creates a MCMethodDefinition from the receiver"

	^ self basicAsMCMethodDefinition
]

{ #category : '*Monticello-Model' }
CompiledMethod >> basicAsMCMethodDefinition [
	"Creates a MCMethodDefinition from the receiver"

	^ MCMethodDefinition
		  className: self methodClass instanceSide name
		  classIsMeta: self isClassSide
		  selector: self selector
		  category: self protocolName
		  sourcePointer: self sourcePointer
		  source: self sourceCode
]

{ #category : '*Monticello-Model' }
CompiledMethod >> sameAsMCDefinition: anMCMethodDefinition [

	^ anMCMethodDefinition selector = self selector and: [
		  anMCMethodDefinition className = self methodClass name and: [
			  anMCMethodDefinition classIsMeta = self isClassSide and: [
				  anMCMethodDefinition protocol = self protocolName and: [ anMCMethodDefinition source = self sourceCode ] ] ] ]
]
