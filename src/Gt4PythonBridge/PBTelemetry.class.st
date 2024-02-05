Class {
	#name : #PBTelemetry,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBTelemetry class >> pythonClass [
	^#Telemetry
]

{ #category : #accessing }
PBTelemetry >> allChildren [
	^ self children , (self children flatCollect: #children)
]

{ #category : #accessing }
PBTelemetry >> children [
	^ self newCommandFactory
		<< (self => 'children');
		sendAndWait
]

{ #category : #accessing }
PBTelemetry >> duration [
	^ self newCommandFactory
		<< (self => #duration callWith: #());
		sendAndWait
]
