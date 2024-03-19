Class {
	#name : #GtPythonTextDataSource,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonTextDataSource class >> pythonClass [
	^ 'gtoolkit_bridge.gtoolkit.phlow.data_source.GtPhlowTextDataSource'
]

{ #category : #accessing }
GtPythonTextDataSource >> getText [
	^ self newCommandFactory
		<< (self => #getText callWith: #());
		sendAndWait
]
