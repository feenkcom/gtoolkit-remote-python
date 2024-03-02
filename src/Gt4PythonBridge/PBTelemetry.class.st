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
	^ self children
		, (self children
				flatCollect: [ :each | [ each children ] onErrorDo: [ :ex | #() ] ])
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

{ #category : #accessing }
PBTelemetry >> withAllChildren [
	^ {self} , self allChildren
]
