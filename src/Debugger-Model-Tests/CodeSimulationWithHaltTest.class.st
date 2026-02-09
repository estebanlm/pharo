Class {
	#name : 'CodeSimulationWithHaltTest',
	#superclass : 'CodeSimulationTest',
	#category : 'Debugger-Model-Tests',
	#package : 'Debugger-Model-Tests'
}

{ #category : 'tests' }
CodeSimulationWithHaltTest >> methodWithHalt [
	<haltOrBreakpointForTesting>
	self halt
]

{ #category : 'tests' }
CodeSimulationWithHaltTest >> testHalt [
	self should: [ self runSimulated: [ self methodWithHalt ] ] raise: Halt
]

{ #category : 'tests' }
CodeSimulationWithHaltTest >> testHaltWithHaltHandler [
	self
		runSimulated: [ [ self methodWithHalt ]
				on: Halt
				do: [ :err |  ] ]
]
