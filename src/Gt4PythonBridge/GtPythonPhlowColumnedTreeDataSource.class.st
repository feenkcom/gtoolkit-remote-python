Class {
	#name : #GtPythonPhlowColumnedTreeDataSource,
	#superclass : #GtPythonPhlowColumnedListDataSource,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
GtPythonPhlowColumnedTreeDataSource class >> pythonClass [
	^ 'gtoolkit_bridge.gtoolkit.phlow.data_source.GtPhlowColumnedTreeDataSource'
]

{ #category : #accessing }
GtPythonPhlowColumnedTreeDataSource >> retrieveChildrenForNodeAtPath: aNodePath [
	^ self newCommandFactory
		<< (self => #retrieveChildrenForNodeAtPath callWith: {aNodePath});
		sendAndWait
]

{ #category : #accessing }
GtPythonPhlowColumnedTreeDataSource >> retriveSentItemAtPath: aNodePath [
	^ self newCommandFactory
		<< (self => #retriveSentItemAtPath callWith: {aNodePath});
		sendAndWait
]
