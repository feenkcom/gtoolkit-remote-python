Class {
	#name : #PushUmlBeaconSignalGroup,
	#superclass : #Object,
	#instVars : [
		'signals'
	],
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PushUmlBeaconSignalGroup class >> signals: aCollection [
	^self new signals: aCollection 
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> getGeoData [
	
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> gtArgViewFor: aView [
	<gtView>
	| view |
	view := aView columnedList
			title: 'Arguments';
			priority: 1;
			items: [ signals ];
			column: 'duration' text: [ :item | item duration ];
			column: 'ret queue'
				text: [ :item | 'Array size: ' , item returnQueue size printString ];
			column: 'verkehrsart' text: [ :each | each args at: 'verkehrsart' ];
			column: 'queue'
				text: [ :each | 'Array size: ' , (each args at: 'queue') size printString ];
			column: 'entlastungsroute'
				text: [ :each | (each args at: 'entlastungsroute') pythonString ].
	^ view
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> gtViewFor: aView [
	<gtView>
	| view |
	view := aView columnedList
			title: 'Routes';
			priority: 2;
			items: [ signals ];
			column: 'route'
				text: [ :item | 
					| ent |
					ent := item entlastungsroute.
					'Length: ' , ent length printString , ' ' , ent pythonString ].
	^ view
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> inject: aValue into: aBlock [
	^signals inject: aValue into: aBlock
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> signals: aCollection [
	signals := aCollection
]

{ #category : #accessing }
PushUmlBeaconSignalGroup >> size [
	^signals size
]
