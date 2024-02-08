Class {
	#name : #PBArgumentMethodStartSignal,
	#superclass : #PBMethodStartSignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBArgumentMethodStartSignal class >> pythonClass [
	^ #ArgumentMethodStartSignal
]

{ #category : #accessing }
PBArgumentMethodStartSignal >> args [
	^self attributeAt: #args
]
