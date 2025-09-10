Extension { #name : 'CompiledCode' }

{ #category : '*DebugInfo' }
CompiledCode >> debugInfo [

	^ (DebugInfoBuilder for: self) build
]
