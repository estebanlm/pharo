Class {
	#name : 'ReBrowseMethodsChoice',
	#superclass : 'ReMethodChoice',
	#category : 'Refactoring-UI-Choices',
	#package : 'Refactoring-UI',
	#tag : 'Choices'
}

{ #category : 'accessing' }
ReBrowseMethodsChoice >> action [
	
	driver browseMethods 
]

{ #category : 'accessing' }
ReBrowseMethodsChoice >> description [ 

	^ 'Browse the methods'
]
