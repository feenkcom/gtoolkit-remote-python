Class {
	#name : #PBArgumentBeaconSignal,
	#superclass : #PBBeaconSignal,
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
