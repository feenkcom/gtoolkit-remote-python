Class {
	#name : #GtPythonPhlowForwarderView,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonPhlowForwarderView class >> pythonClass [
	^ #ForwardView
]

{ #category : #accessing }
GtPythonPhlowForwarderView >> getDeclarativeViewFor: viewSelector [
	^ self newCommandFactory
		<< (self => #getDataSource callWith: {viewSelector});
		sendAndWait
]

{ #category : #accessing }
GtPythonPhlowForwarderView >> retrieveViewSpecificationForForwarding [
	^ self newCommandFactory
		<< (self => #getViewSpecificationForForwarding) call;
		sendAndWait
]
