Class {
	#name : #PBBeaconSignal,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBBeaconSignal class >> pythonClass [
	^ #BeaconSignal
]

{ #category : #accessing }
PBBeaconSignal >> attributeAt: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (self => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBBeaconSignal >> attributeOf: aProxy at: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (aProxy => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBBeaconSignal >> children [
	^self attributeAt: #children
]

{ #category : #accessing }
PBBeaconSignal >> duration [
	^ self newCommandFactory
		<< (self => #duration callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBBeaconSignal >> file [
	| filename model |
	filename := (self attributeAt: #file) asFileReference.
	model := GtLSPPythonModel onDirectory:  filename parent.
	^ GtLSPFileModel new
		filename: filename;
		directory: model;
		yourself
]

{ #category : #accessing }
PBBeaconSignal >> gtSourceFor: aView [
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
PBBeaconSignal >> line [
	^self attributeAt: #line
]

{ #category : #accessing }
PBBeaconSignal >> message [
	^self attributeAt: #message
]
