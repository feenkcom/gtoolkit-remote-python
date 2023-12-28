Class {
	#name : #PushUmlBeaconSignal,
	#superclass : #PBBeaconSignal,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PushUmlBeaconSignal class >> pythonClass [
	^ #PushUmlBeaconSignal
]

{ #category : #accessing }
PushUmlBeaconSignal >> args [
	^self attributeAt: #args
]

{ #category : #accessing }
PushUmlBeaconSignal >> entlastungsroute [
	^ self newCommandFactory
		<< (self => #entlastungsroute callWith: #());
		sendAndWait
]

{ #category : #accessing }
PushUmlBeaconSignal >> gtRouteMapView: aView [
	<gtView>
	^ aView mondrian
		title: 'Route Map';
		priority: 1;
		painting: [ :m | 
			| jDict |
			jDict := self nodeGeoList.
			m nodes
				stencil: [ :j | 
					| deg |
					deg := self nodeDegree: (j at: 'node').
					BlElement new
						geometry: BlCircleGeometry new;
						size: 10 @ 10;
						relocate: ((j at: 'lon') * 1500) @ ((j at: 'lat') * 1000) negated;
						background: Color black ];
				with: jDict.
			m edges
				stencil: [ :e | BlLineElement new border: (BlBorder paint: Color black) ];
				connect: ((1 to: jDict size - 1) collect: [ :i | i -> (i + 1) ])
					from: [ :each | jDict at: each key ]
					to: [ :each | jDict at: each value ].
			m layout explicit: BlBasicLayout new.
			m ]
]

{ #category : #accessing }
PushUmlBeaconSignal >> gtRouteView: aView [
	<gtView>
	^aView remoteForward
		title: 'Route';
		priority: 2;
		object: [self entlastungsroute];
		view: #gtViewRoute
]

{ #category : #accessing }
PushUmlBeaconSignal >> nodeDegree: aString [
	^ self newCommandFactory
		<< (self => #node_degree callWith: { aString });
		sendAndWait
]

{ #category : #accessing }
PushUmlBeaconSignal >> nodeGeoList [
	^ self newCommandFactory
		<< (self => #node_geo_list callWith: #());
		sendAndWait
]

{ #category : #accessing }
PushUmlBeaconSignal >> returnQueue [
	^self attributeAt: #return_queue
]
