Class {
	#name : #GtPythonPhlowListingDataSource,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonPhlowListingDataSource class >> pythonClass [
	^ #GtPhlowListingDataSource
]

{ #category : #accessing }
GtPythonPhlowListingDataSource >> flushItemsIterator [
	self newCommandFactory
		<< (self => #flushItemsIterator) call;
		sendAndWait
]

{ #category : #accessing }
GtPythonPhlowListingDataSource >> retrieveItems: count fromIndex: startIndex [
	^ self newCommandFactory
		<< (self => #retrieveItems
				callWith: {count.
						startIndex});
		sendAndWait
]

{ #category : #accessing }
GtPythonPhlowListingDataSource >> retriveSentItemAt: anInteger [
	^ self newCommandFactory
		<< (self => #retriveSentItemAt callWith: {anInteger});
		sendAndWait
]
