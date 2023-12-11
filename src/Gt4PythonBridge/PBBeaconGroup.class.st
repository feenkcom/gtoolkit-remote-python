Class {
	#name : #PBBeaconGroup,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBBeaconGroup class >> pythonClass [
	^ #BeaconGroup
]

{ #category : #accessing }
PBBeaconGroup >> attributeOf: aProxy at: attributeString [
	"Answer the value of the named attribute"

	^ self newCommandFactory
		<< (aProxy => attributeString);
		sendAndWait
]

{ #category : #accessing }
PBBeaconGroup >> beaconList [
	^ self newCommandFactory
		<< (self => #get_beacons callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBBeaconGroup >> beaconTree [
	^ self newCommandFactory
		<< (self => #get_beacon_tree callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBBeaconGroup >> durationOf: aBeaconProxy [
	^ self newCommandFactory
		<< (aBeaconProxy => #duration callWith: #());
		sendAndWait 
]

{ #category : #accessing }
PBBeaconGroup >> gtBarElements [
	| tree |
	tree := self beaconTree.
	^ self
		gtBarElementsFor: tree first
		withGlobalWeight: 1.0
		local: 1.0
]

{ #category : #accessing }
PBBeaconGroup >> gtBarElementsFor: aBeacon withGlobalWeight: aWeight local: aLocalWeight [
	| taskElements aBarColor |
	aBarColor := BlColorTransition
			interpolate: Color veryLightGray
			to: BrGlamorousColors errorBorderColor
			at: aWeight.

	taskElements := aWeight > 0.1
			ifTrue: [ | myDuration |
				myDuration := self durationOf: aBeacon first.

				aBeacon second
					collect: [ :anEvent | 
						| eachWeight |
						eachWeight := myDuration isZero
								ifTrue: [ 0 ]
								ifFalse: [ ((self durationOf: anEvent first) / myDuration) asFloat ].
						(self
							gtBarElementsFor: anEvent
							withGlobalWeight: eachWeight * aWeight
							local: eachWeight)
							constraintsDo: [ :c | c linear weight: (eachWeight max: 0.001) ] ] ]
			ifFalse: [ aBeacon second
					ifEmpty: [ #() ]
					ifNotEmpty: [ {BlElement new
								layout: BlLinearLayout horizontal;
								constraintsDo: [ :c | 
									c horizontal matchParent.
									c vertical exact: 20 ];
								when: BlClickEvent
									do: [ :anEvent | 
										anEvent consumed: true.
										anEvent currentTarget phlow spawnObject: aBeacon first ];
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
						anEvent currentTarget phlow spawnObject: aBeacon first ];
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
										text: (self attributeOf: aBeacon first at: #message)) asScalableElement ] ];
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
PBBeaconGroup >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 3;
		stencil: [  self
				gtBarElements ]
]
