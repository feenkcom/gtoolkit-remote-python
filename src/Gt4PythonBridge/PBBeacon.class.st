Class {
	#name : #PBBeacon,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBBeacon class >> pythonClass [
	^ #Beacon
]

{ #category : #accessing }
PBBeacon >> attributeAt: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (self => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBBeacon >> attributeOf: aProxy at: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (aProxy => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBBeacon >> children [
	^self attributeAt: #children
]

{ #category : #accessing }
PBBeacon >> duration [
	^ self newCommandFactory
		<< (self => #duration callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBBeacon >> file [
	| filename model |
	filename := (self attributeAt: #file) asFileReference.
	model := GtLSPPythonModel onDirectory:  filename parent.
	^ GtLSPFileModel new
		filename: filename;
		directory: model;
		yourself
]

{ #category : #accessing }
PBBeacon >> gtSourceFor: aView [
	<gtView>
	^ aView forward
		title: 'Source';
		object: [ GtLSPFileLocation new
				lspFile: self file;
				startPosition: (GtLSPPositionStructure new
						line: self line - 1;
						character: 0;
						yourself);
				endPosition: (GtLSPPositionStructure new
						line: self line - 1;
						character: (self file source lineNumber: self line) size;
						yourself) ];
		view: #gtLiveFor:
]

{ #category : #accessing }
PBBeacon >> line [
	^self attributeAt: #line
]

{ #category : #accessing }
PBBeacon >> message [
	^self attributeAt: #message
]
