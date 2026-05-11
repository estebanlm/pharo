"
A class to execute commands from command Line.
We can parse commands and arguments, and execute the dedicated method
"
Class {
	#name : 'CommandLineDebugger',
	#superclass : 'Object',
	#instVars : [
		'isActive',
		'context',
		'process',
		'lineEnding',
		'commands',
		'commandsStack'
	],
	#category : 'debugger-CLI',
	#package : 'debugger-CLI'
}

{ #category : 'initialization' }
CommandLineDebugger >> activate [

	isActive := true
]

{ #category : 'execution' }
CommandLineDebugger >> commandClassInstanceFor: aString [
	"Gives the right command class to use"

	[ ^ commands at: aString ]
		on: Error
		do: [ :ex |
				ex class name = #KeyNotFound
					ifTrue: [ ^ UnknownCommand new command: aString ]
					ifFalse: [ ex pass ] ]
]

{ #category : 'accessing' }
CommandLineDebugger >> commands [

	^ commands
]

{ #category : 'accessing' }
CommandLineDebugger >> commands: anObject [

	commands := anObject
]

{ #category : 'initialization' }
CommandLineDebugger >> completeStep [

	| callee |
	process suspendedContext == context ifFalse: [ ^ process complete: (process calleeOf: context) ].
	callee := process step.
	callee == context ifTrue: [ ^ callee ].
	context isDead ifTrue: [ ^ process suspendedContext ].
	^ process complete: callee "finish send"
]

{ #category : 'initialization' }
CommandLineDebugger >> context [

	^ context
]

{ #category : 'initialization' }
CommandLineDebugger >> context: aDebugContext [
    context := aDebugContext
]

{ #category : 'initialization' }
CommandLineDebugger >> disActivate [

	isActive := false
]

{ #category : 'execution' }
CommandLineDebugger >> executeCommand: aCommand arg: arguments [
	"executes the command with potential arguments"

	^ (self commandClassInstanceFor: aCommand) executeOn: self with: arguments
]

{ #category : 'execution' }
CommandLineDebugger >> finishedDebugging [

	isActive := false.
	^ 'Execution finished. The program has ended.'
]

{ #category : 'initialization' }
CommandLineDebugger >> initialize [

	super initialize.
	isActive := true.
	lineEnding := OSPlatform current lineEnding.
	self initializeCommands.
	commandsStack := Stack new.
]

{ #category : 'initialization' }
CommandLineDebugger >> initializeCommands [

	| commandsList |
	commandsList := {
		                ExitCommand new.
		                HelpCommand new.
		                StepCommand new.
		                OverCommand new.
		                PrintCodeCommand new.
		                PrintCommand new.
		                PrintStackCommand new }.
	commands := Dictionary new.
	commandsList do: [ :aCommand |
			commands at: aCommand commandName first put: aCommand.
			commands at: aCommand commandName last put: aCommand ]
]

{ #category : 'initialization' }
CommandLineDebugger >> isActive [
    ^ isActive
]

{ #category : 'initialization' }
CommandLineDebugger >> lastCommand [
	
	commandsStack ifNotEmpty: [ ^ commandsStack pop ]
	ifEmpty: [ ^ '' ]
	
]

{ #category : 'accessing' }
CommandLineDebugger >> lineEnding [

	^ lineEnding
]

{ #category : 'accessing' }
CommandLineDebugger >> lineEnding: anObject [

	lineEnding := anObject
]

{ #category : 'execution' }
CommandLineDebugger >> parsesAndExecuteCommand: aString [
	"Parses a string to change it into an executable command and executes it"

	| subString command arguments |
	commandsStack push: aString.
	subString := aString trim substrings.
	subString ifEmpty: [ ^ '' ].

	command := subString first.

	arguments := subString allButFirst joinUsing: ' '.

	^ self executeCommand: command arg: arguments
]

{ #category : 'initialization' }
CommandLineDebugger >> process [

	^ process
]

{ #category : 'initialization' }
CommandLineDebugger >> process: aProcess [

	process := aProcess
]
