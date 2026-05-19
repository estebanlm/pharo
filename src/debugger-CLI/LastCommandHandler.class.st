"
""Handles the command !! and return the most recent command typed ""
"
Class {
	#name : 'LastCommandHandler',
	#superclass : 'DebuggerHistoryHandler',
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'testing' }
LastCommandHandler >> canHandle: aString [

	^ aString beginsWith: '!!'
]

{ #category : 'testing' }
LastCommandHandler >> handle: aString for: aDebugger [
    ^ aDebugger lastCommand , (aString allButFirst: 2)
]
