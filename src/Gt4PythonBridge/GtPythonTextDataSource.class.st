Class {
	#name : #GtPythonTextDataSource,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonTextDataSource class >> pythonClass [
	^ #GtPhlowTextDataSource
]

{ #category : #accessing }
GtPythonTextDataSource >> getText [
	^ self newCommandFactory
		<< (self => #getText callWith: #());
		sendAndWait
]
