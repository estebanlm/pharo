"
""Handles the command !?<aString> and return (if it exists) the most recent typed contaning aString""
"
Class {
	#name : 'ContansStringHandler',
	#superclass : 'DebuggerHistoryHandler',
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'testing' }
ContansStringHandler >> canHandle: aString [
	
	^ aString beginsWith: '!?'
]

{ #category : 'testing' }
ContansStringHandler >> handle: aString for: aDebugger [

	| unMot commandsArray |
	unMot := aString copyFrom: 3 to: aString size.

	commandsArray := aDebugger commandsStack asArray.
	^ commandsArray detect: [ :command | command includesSubstring: unMot ] ifNone: [ HistoryEventNotFound signal: aString , ': event not found' ]
]
