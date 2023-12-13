Class {
	#name : #PBBeaconSignalGroup,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBBeaconSignalGroup class >> pythonClass [
	^ #BeaconSignalGroup
]

{ #category : #accessing }
PBBeaconSignalGroup >> gtBarElements [
	| tree |
	tree := self signalTree.
	^ tree first gtBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBBeaconSignalGroup >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 3;
		stencil: [  self
				gtBarElements ] 
]

{ #category : #accessing }
PBBeaconSignalGroup >> signalList [
	^ self newCommandFactory
		<< (self => #get_signals callWith: #());
		sendAndWait
]

{ #category : #accessing }
PBBeaconSignalGroup >> signalTree [
	^ self newCommandFactory
		<< (self => #get_signal_tree callWith: #());
		sendAndWait
]
