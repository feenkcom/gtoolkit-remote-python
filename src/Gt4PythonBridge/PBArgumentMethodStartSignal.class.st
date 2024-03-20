Class {
	#name : #PBArgumentMethodStartSignal,
	#superclass : #PBMethodStartSignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBArgumentMethodStartSignal class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.telemetry.ArgumentMethodStartSignal'
]

{ #category : #accessing }
PBArgumentMethodStartSignal >> aggregateClass [
	^PBArgumentMethodStartSignalGroup
]

{ #category : #accessing }
PBArgumentMethodStartSignal >> kwargs [
	^self attributeAt: #kwargs
]
