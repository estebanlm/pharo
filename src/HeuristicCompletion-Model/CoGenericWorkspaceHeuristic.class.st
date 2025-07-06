Class {
	#name : 'CoGenericWorkspaceHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#instVars : [
		'fetcher'
	],
	#category : 'HeuristicCompletion-Model-Heuristics',
	#package : 'HeuristicCompletion-Model',
	#tag : 'Heuristics'
}

{ #category : 'requests' }
CoGenericWorkspaceHeuristic >> appliesForNode: aNode inContext: aContext [

	^ aContext isScripting
]

{ #category : 'requests' }
CoGenericWorkspaceHeuristic >> buildFetcherFor: aNode inContext: aContext [

	^ fetcher
]

{ #category : 'requests' }
CoGenericWorkspaceHeuristic >> fetcher: aFetcher [

	fetcher := aFetcher
]
