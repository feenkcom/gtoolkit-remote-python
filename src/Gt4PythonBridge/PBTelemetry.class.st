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
PBTelemetry >> aggregateClass [
	^nil
]

{ #category : #accessing }
PBTelemetry >> allChildren [
	^ self children , (self children flatCollect: #children)
]

{ #category : #accessing }
PBTelemetry >> children [
	^ self newCommandFactory
		<< (self => 'children' callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBTelemetry >> duration [
	^ self newCommandFactory
		<< (self => #duration callWith: #());
		sendAndWait
]
