Class {
	#name : 'TPropertiesMockTest',
	#superclass : 'TestCase',
	#traits : 'TPropertiesTraitTest',
	#classTraits : 'TPropertiesTraitTest classTrait',
	#instVars : [
		'keyAccess',
		'removeKey'
	],
	#category : 'Kernel-Traits-Tests',
	#package : 'Kernel-Traits-Tests'
}

{ #category : 'requirements' }
TPropertiesMockTest >> classWithProperties [
	| class |

	class := TPropertiesMock new.
	^ class
		propertyAt: #a put: 'a';
		propertyAt: #b put: 42;
		propertyAt: #c put: 'a'; 
		propertyAt: #d put: -2; 
		yourself. 
]

{ #category : 'requirements' }
TPropertiesMockTest >> keyNotIn [ 
	^#z
]

{ #category : 'requirements' }
TPropertiesMockTest >> valueNotIn [ 
	^700
]
