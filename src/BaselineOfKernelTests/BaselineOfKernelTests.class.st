Class {
	#name : 'BaselineOfKernelTests',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfKernelTests',
	#package : 'BaselineOfKernelTests'
}

{ #category : 'baselines' }
BaselineOfKernelTests >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'Compression-Tests';
				package: 'FileSystem-Core-Tests';
				package: 'FileSystem-Disk-Tests';
				package: 'FileSystem-Tests-Attributes';
				package: 'Files-Tests';
				package: 'Jobs-Tests';
				package: 'Random-Tests';
				package: 'Ring-Definitions-Core-Tests';
				package: 'Ring-Definitions-Tests-Containers';
				package: 'System-OSEnvironments-Tests' ]
]
