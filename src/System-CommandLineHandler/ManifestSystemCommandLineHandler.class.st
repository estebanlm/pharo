"
Package to provide basic command line handling.
"
Class {
	#name : 'ManifestSystemCommandLineHandler',
	#superclass : 'PackageManifest',
	#category : 'System-CommandLineHandler-Manifest',
	#package : 'System-CommandLineHandler',
	#tag : 'Manifest'
}

{ #category : 'meta-data - dependency analyser' }
ManifestSystemCommandLineHandler class >> ignoredDependencies [
	^ #(#'System-Settings-Core' #StartupPreferences #'System-Hashing')
]

{ #category : 'meta-data - dependency analyser' }
ManifestSystemCommandLineHandler class >> manuallyResolvedDependencies [
	^ #( #'Collections-Abstract' #'FileSystem-Core' #'System-Support' #'Kernel-CodeModel' #'System-Settings-Core' #'Collections-Streams' #'System-Hashing')
]
