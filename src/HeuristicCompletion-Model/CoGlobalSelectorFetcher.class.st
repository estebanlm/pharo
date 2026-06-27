"
I am a fetcher that gets all message selectors. 
I use the SystemNavigation to get all selectors and then filtering them.
See the #entriesDo:
"
Class {
	#name : 'CoGlobalSelectorFetcher',
	#superclass : 'CoGlobalFetcher',
	#classVars : [
		'TokenSizes'
	],
	#category : 'HeuristicCompletion-Model-Fetchers',
	#package : 'HeuristicCompletion-Model',
	#tag : 'Fetchers'
}

{ #category : 'class initialization' }
CoGlobalSelectorFetcher class >> fillTokenSizes [
	"self fillTokenSizes"
	
	TokenSizes := Array new: 200 withAll: 1.
	
	2 to: TokenSizes size  do: [ :i | 
		TokenSizes at: i put: (i - ((i-1) log: 2)) floor ].
	TokenSizes at: 2 put: 1.
	^ TokenSizes
]

{ #category : 'class initialization' }
CoGlobalSelectorFetcher class >> initialize [ 
	"self initialize"
	
	self fillTokenSizes
]

{ #category : 'enumerating' }
CoGlobalSelectorFetcher >> entriesDo: aBlock [
	"We try two approaches
	
	- the first one is to see if we can take advantage that we are in the beginning of a keyword message.
	
	For example imagine that the user 
			
			x at: a p|  
			
	we are trying to propose at:put:.		 
			
	- the last one is to look globally in the method implementors and try to match. 		
	"
	
	| size coml |
	astNode ifNotNil: [ :node |
		node parent ifNotNil: [ :parent | 
			"Try first to continue the parent keyword message"
			(parent isMessage and: [ parent isKeyword ]) ifTrue: [
				self systemNavigation 
					allSelectorsStartingWith: parent selector 
					do: [ :e |
						aBlock value: (CoSelectorEntry new
							displayedContents:
								'(' , (e copyFrom: 1 to: parent selector size) , ')' , (e copyFrom: parent selector size + 1 to: e size);
							contents: (e copyFrom: parent selector size + 1 to: e size);
							node: astNode;
							fetcherName: self class name;
							selector: e) ] ] ] ]. 
	"Otherwise, just go wide"
	coml := filter completionString.
	size := coml size.
	
	"here we are trying to guide less the collection of possible matches so that the tolerance can then play its role
	Indeed if we are looking for SpPresenter and type SpPrez looking for SpPrez* will not give SpPresenter so the idea if to reduce the 
	length of the prefix so that at the end of the prefix we get more chances of copiing with typos."
	self systemNavigation 
		allSelectorsStartingWith: 
			(coml copyFrom: 1 to: (TokenSizes at: size))   
		do: [ :e |
				aBlock value: ((CoSelectorEntry contents: e node: astNode)
					 fetcherName: self class name;
					 yourself) ]
]
