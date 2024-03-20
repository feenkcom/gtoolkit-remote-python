Class {
	#name : #GtPythonRemotePhlowViewedObject,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonRemotePhlowViewedObject class >> pythonClass [
	^ 'gtoolkit_bridge.gtoolkit.gt.GtViewedObject'
]

{ #category : #accessing }
GtPythonRemotePhlowViewedObject >> getDeclarativeViewFor: viewSelector [
	^ self newCommandFactory
		<< (self => #getDataSource callWith: {viewSelector});
		sendAndWait
]

{ #category : #accessing }
GtPythonRemotePhlowViewedObject >> getDeclarativeViewMethodNames [
	^ self newCommandFactory
		<< (self => #getGtViewMethodNames) call;
		sendAndWait
]

{ #category : #accessing }
GtPythonRemotePhlowViewedObject >> getViewDeclaration: viewSelector [
	^ self newCommandFactory
		<< (self => #getViewDeclaration callWith: {viewSelector});
		sendAndWait
]

{ #category : #accessing }
GtPythonRemotePhlowViewedObject >> getViewsDeclarations [
	^ self newCommandFactory
		<< (self => #getViewsDeclarations) call;
		sendAndWait
]
