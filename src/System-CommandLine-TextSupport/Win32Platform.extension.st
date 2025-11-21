Extension { #name : 'Win32Platform' }

{ #category : '*System-CommandLine-TextSupport' }
Win32Platform >> newTerminfo [
	"Windows does not support the termCap"
	^ NullTermInfo new
]
