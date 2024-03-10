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
PBTelemetrySignalGroup >> allChildren [
	^self eventTree flatCollect: #withAllChildren
]

{ #category : #accessing }
PBTelemetrySignalGroup >> eventTree [
	^ self callMethod: #get_event_tree
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
	^ aView columnedList
		title: 'Consolidated';
		priority: 4;
		items: [ | groups |
			groups := (self allChildren groupedBy: [ :each | each attributeAt: #message ])
					associations.
			groups
				do: [ :assoc | 
					| anEvent |
					anEvent := assoc value first.
					(anEvent respondsTo: #aggregateClass)
						ifTrue: [ anEvent aggregateClass
								ifNotNil: [ :cls | assoc value: (cls signals: assoc value) ] ] ].
			groups ];
		send: [ :assoc | assoc value ];
		column: 'Message' text: [ :item | item key ];
		column: 'Count' text: [ :item | item value size ]
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtBeaconMapView: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		priority: 3;
		stencil: [ self gtBarElements ]
]

{ #category : #accessing }
PBTelemetrySignalGroup >> gtConsolidatedBarElements [
	| tree |
	tree := self eventTree.
	^ tree first gtConsolidatedBarElementsWithGlobalWeight: 1.0 local: 1.0
]

{ #category : #accessing }
PBTelemetrySignalGroup >> signalList [
	^ self callMethod: #get_signals
]
