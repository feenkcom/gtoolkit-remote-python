Class {
	#name : #PBTelemetryEvent,
	#superclass : #PBTelemetry,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBTelemetryEvent class >> pythonClass [
	^#TelemetryEvent
]

{ #category : #accessing }
PBTelemetryEvent >> aggregateClass [
	^self startSignal aggregateClass
]

{ #category : #accessing }
PBTelemetryEvent >> gtBarElements [
	^ self gtBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBTelemetryEvent >> gtBarElementsWithGlobalWeight: aWeight local: aLocalWeight [
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
								ifFalse: [ (anEvent duration / myDuration) asFloat ].
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
										text: self message) asScalableElement ] ];
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
PBTelemetryEvent >> gtBeaconConsolidatedView: aView [
	<gtView>
	^ aView columnedList
		title: 'Consolidated';
		priority: 4;
		items: [ | groups |
			groups := (self allChildren groupedBy: #message) associations.
			groups
				do: [ :assoc | 
					assoc value first aggregateClass
						ifNotNil: [ :cls | assoc value: (cls signals: assoc value) ] ].
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
PBTelemetryEvent >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [  self
				gtBarElements ]
]

{ #category : #accessing }
PBTelemetryEvent >> message [
	^ self newCommandFactory
		<< (self => 'message');
		sendAndWait
]

{ #category : #accessing }
PBTelemetryEvent >> signals [
	^ self newCommandFactory
		<< (self => 'signals');
		sendAndWait
]

{ #category : #accessing }
PBTelemetryEvent >> startSignal [
	^ self newCommandFactory
		<< (self => 'startSignal');
		sendAndWait
]
