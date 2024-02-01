Class {
	#name : #PBMethodStartSignal,
	#superclass : #PBTelemetrySignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBMethodStartSignal class >> pythonClass [
	^ #MethodStartSignal
]

{ #category : #accessing }
PBMethodStartSignal >> args [
	^self attributeAt: #args
]
