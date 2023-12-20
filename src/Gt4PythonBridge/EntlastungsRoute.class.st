Class {
	#name : #EntlastungsRoute,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
EntlastungsRoute class >> pythonClass [
	^#EntlastungsRoute
]

{ #category : #accessing }
EntlastungsRoute >> duration [
	^ self newCommandFactory
		<< (self => #duration callWith: #());
		sendAndWait
]

{ #category : #accessing }
EntlastungsRoute >> length [
	^ self newCommandFactory
		<< (self => 'length');
		sendAndWait
]

{ #category : #accessing }
EntlastungsRoute >> pythonString [
	^ self newCommandFactory
		<< (self => #_get_route_string callWith: #());
		sendAndWait
]
