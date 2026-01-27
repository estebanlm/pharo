Class {
	#name : 'NoSourcesManager',
	#superclass : 'SourcesManager',
	#category : 'System-Sources-Sources',
	#package : 'System-Sources',
	#tag : 'Sources'
}

{ #category : 'accessing' }
NoSourcesManager >> commentTimeStampAt: sourcePointer [

	^ ''
]

{ #category : 'accessing' }
NoSourcesManager >> protocolAt: sourcePointer [

	^ 'unfound protocol'
]

{ #category : 'accessing' }
NoSourcesManager >> sourceCodeAt: sourcePointer [

	^ nil
]

{ #category : 'accessing' }
NoSourcesManager >> timeStampAt: sourcePointer [

	^ ''
]

{ #category : 'writing' }
NoSourcesManager >> writeComment: aString stamp: aStamp of: aClass [
	"We do nothing in this one"

	
]

{ #category : 'writing' }
NoSourcesManager >> writeSource: source of: aMethod withFooter: footer protocol: protocol timestamp: aTimestamp priorSourcePointer: priorSourcePointer [
	"Since we can not store the source pointer, we put back the property"

	aMethod propertyAt: #source put: source
]
