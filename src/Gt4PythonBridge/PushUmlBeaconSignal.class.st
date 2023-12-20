Class {
	#name : #PushUmlBeaconSignal,
	#superclass : #PBBeaconSignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PushUmlBeaconSignal class >> pythonClass [
	^ #PushUmlBeaconSignal
]

{ #category : #accessing }
PushUmlBeaconSignal >> args [
	^self attributeAt: #args
]

{ #category : #accessing }
PushUmlBeaconSignal >> entlastungsroute [
	^ self newCommandFactory
		<< (self => #entlastungsroute callWith: #());
		sendAndWait
]

{ #category : #accessing }
PushUmlBeaconSignal >> returnQueue [
	^self attributeAt: #return_queue
]
