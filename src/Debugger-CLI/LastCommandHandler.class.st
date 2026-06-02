"
""Handles the command !! and return the most recent command typed ""
"
Class {
	#name : 'LastCommandHandler',
	#superclass : 'DebuggerHistoryHandler',
	#category : 'Debugger-CLI',
	#package : 'Debugger-CLI'
}

{ #category : 'testing' }
LastCommandHandler >> canHandle: aString [

	^ aString beginsWith: '!!'
]

{ #category : 'testing' }
LastCommandHandler >> handle: aString for: aDebugger [
    ^ aDebugger lastCommand , (aString allButFirst: 2)
]
