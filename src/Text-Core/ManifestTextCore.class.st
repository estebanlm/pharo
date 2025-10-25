"
Handling of Text and related text attributes
"
Class {
	#name : 'ManifestTextCore',
	#superclass : 'PackageManifest',
	#category : 'Text-Core-Manifest',
	#package : 'Text-Core',
	#tag : 'Manifest'
}

{ #category : 'Protocol (meta-data - dependency analyser) - 1 selector(s)' }
ManifestTextCore class >> manuallyResolvedDependencies [
	^ #(#'Fonts-Infrastructure' #'AST-Core' #'Collections-Abstract' #'System-Support')
]
