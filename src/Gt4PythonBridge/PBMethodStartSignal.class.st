Class {
	#name : #PBMethodStartSignal,
	#superclass : #PBTelemetrySignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBMethodStartSignal class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.telemetry.MethodStartSignal'
]

{ #category : #accessing }
PBMethodStartSignal >> args [
	^self attributeAt: #args
]
