Extension { #name : 'String' }

{ #category : '*System-Time' }
String >> asDateAndTime [
 	"Convert from UTC format"

	^ DateAndTime fromString: self
]
