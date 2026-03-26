"
I am a command to inline ""self send"" method directly into sender method
"
Class {
	#name : 'SycInlineMethodCommand',
	#superclass : 'SycSourceCodeRefactoringCommand',
	#category : 'SystemCommands-SourceCodeCommands',
	#package : 'SystemCommands-SourceCodeCommands'
}

{ #category : 'testing' }
SycInlineMethodCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isMethodSelected not and: [
			  aSourceCodeContext isMessageSelected ] ]
]

{ #category : 'accessing' }
SycInlineMethodCommand >> defaultMenuIconName [
	^ #smallRightFlush
]

{ #category : 'accessing' }
SycInlineMethodCommand >> defaultMenuItemName [
	^ 'Inline method'
]

{ #category : 'execution' }
SycInlineMethodCommand >> execute [

	^ ((ReInlineMethodDriver newApplication: self application)
		   scopes: refactoringScopes
		   interval: sourceNode sourceInterval
		   selector: method selector
		   class: method origin) runRefactoring 
]
