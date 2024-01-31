Class {
	#name : #PBTelemetrySignal,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBTelemetrySignal class >> pythonClass [
	^ #TelemetrySignal
]

{ #category : #accessing }
PBTelemetrySignal >> attributeAt: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (self => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBTelemetrySignal >> file [
	| filename model |
	filename := (self attributeAt: #file) asFileReference.
	model := GtLSPPythonModel onDirectory:  filename parent.
	^ GtLSPFileModel new
		filename: filename;
		directory: model;
		yourself
]

{ #category : #accessing }
PBTelemetrySignal >> gtBarElements [
	^ self gtBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBTelemetrySignal >> gtBarElementsWithGlobalWeight: aWeight local: aLocalWeight [
	| taskElements aBarColor |
	aBarColor := BlColorTransition
			interpolate: Color veryLightGray
			to: BrGlamorousColors errorBorderColor
			at: aWeight.

	taskElements := aWeight > 0.1
			ifTrue: [ | myDuration |
				myDuration := self duration.

				self children
					collect: [ :anEvent | 
						| eachWeight |
						eachWeight := myDuration isZero
								ifTrue: [ 0 ]
								ifFalse: [ ((anEvent duration) / myDuration) asFloat ].
						(anEvent
							gtBarElementsWithGlobalWeight: eachWeight * aWeight
							local: eachWeight)
							constraintsDo: [ :c | c linear weight: (eachWeight max: 0.001) ] ] ]
			ifFalse: [ self children
					ifEmpty: [ #() ]
					ifNotEmpty: [ {BlElement new
								layout: BlLinearLayout horizontal;
								constraintsDo: [ :c | 
									c horizontal matchParent.
									c vertical exact: 20 ];
								when: BlClickEvent
									do: [ :anEvent | 
										anEvent consumed: true.
										anEvent currentTarget phlow spawnObject: self ];
								geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
								border: (BlBorder paint: Color transparent width: (aWeight max: 0.1));
								background: (BlLinearGradientPaint vertical
										stops: {0 -> aBarColor.
												0.4 -> (aBarColor alpha: 0.5).
												1 -> (aBarColor alpha: 0)})} ] ].

	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BlElement new
				layout: BlLinearLayout horizontal alignCenter;
				when: BlClickEvent
					do: [ :anEvent | 
						anEvent consumed: true.
						anEvent currentTarget phlow spawnObject: self ];
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical exact: 20 ];
				padding: (BlInsets top: 3 bottom: 3);
				geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
				border: (BlBorder paint: Color transparent width: 0.25);
				background: aBarColor;
				in: [ :aPane | 
					aWeight > 0.005
						ifTrue: [ aPane
								addChild: (BrLabel new
										aptitude: (BrGlamorousLabelAptitude new fontSize: 10);
										text: (self message)) asScalableElement ] ];
				yourself);
		addChild: (BlElement new
				layout: (BlLinearLayout horizontal alignTopCenter weightSum: 1);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				addChildren: taskElements);
		yourself
]

{ #category : #accessing }
PBTelemetrySignal >> gtBeaconConsolidatedView: aView [
	<gtView>
	^ aView columnedList
		title: 'Consolidated';
		priority: 4;
		items: [ | groups |
			groups := (self allChildren groupedBy: #message) associations.
			groups
				do: [ :assoc | 
					assoc value first class == PBArgumentBeaconSignal
						ifTrue: [ assoc value: (PBArgumentBeaconSignalGroup signals: assoc value) ].
					"assoc value first class == PushUmlBeaconSignal
						ifTrue: [ assoc value: (PushUmlBeaconSignalGroup signals: assoc value) ]" ].
			groups ];
		send: [ :assoc | assoc value ];
		column: 'Message' text: [ :item | item key ];
		column: 'Count' text: [ :item | item value size ];
		column: 'Duration %'
			text: [ :item | 
				(item value inject: 0 into: [ :sum :each | sum + each duration ])
					/ self duration asFloat * 100.0 printShowingDecimalPlaces: 3 ]
]

{ #category : #accessing }
PBTelemetrySignal >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [  self
				gtBarElements ]
]

{ #category : #accessing }
PBTelemetrySignal >> gtSourceFor: aView [
	<gtView>
	^ aView forward
		title: 'Source';
		priority: 2;
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
PBTelemetrySignal >> line [
	^self attributeAt: #line
]

{ #category : #accessing }
PBTelemetrySignal >> message [
	^self attributeAt: #message
]
