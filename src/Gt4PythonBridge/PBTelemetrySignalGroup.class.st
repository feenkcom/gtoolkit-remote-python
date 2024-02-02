Class {
	#name : #PBTelemetrySignalGroup,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBTelemetrySignalGroup class >> pythonClass [
	^ #TelemetrySignalGroup
]

{ #category : #accessing }
PBTelemetrySignalGroup >> eventTree [
	^ self newCommandFactory
		<< (self => #get_event_tree callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtBarElements [
	| tree |
	tree := self eventTree.
	^ tree first gtBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtBeaconConsolidatedView: aView [
	<gtView>
	^ aView forward
		title: 'Consolidated';
		object: [ self signalList first ];
		view: #gtBeaconConsolidatedView:
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 3;
		stencil: [  self
				gtBarElements ] 
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtConsolidatedBarElements [
	| tree |
	tree := self eventTree.
	^ tree first gtConsolidatedBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBTelemetrySignalGroup >> signalList [
	^ self newCommandFactory
		<< (self => #get_signals callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBTelemetrySignalGroup >> signalTree [
	^ self newCommandFactory
		<< (self => #get_signal_tree callWith: #());
		sendAndWait
]
