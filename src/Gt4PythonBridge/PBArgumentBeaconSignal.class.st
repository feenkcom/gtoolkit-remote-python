Class {
	#name : #PBArgumentBeaconSignal,
	#superclass : #PBMethodStartSignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBArgumentBeaconSignal class >> pythonClass [
	^ #ArgumentBeaconSignal
]

{ #category : #accessing }
PBArgumentBeaconSignal >> args [
	^self attributeAt: #args
]
