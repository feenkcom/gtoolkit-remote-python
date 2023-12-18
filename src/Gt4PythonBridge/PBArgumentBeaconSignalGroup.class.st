Class {
	#name : #PBArgumentBeaconSignalGroup,
	#superclass : #Object,
	#instVars : [
		'signals'
	],
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBArgumentBeaconSignalGroup class >> signals: aCollection [
	^self new signals: aCollection 
]

{ #category : #accessing }
PBArgumentBeaconSignalGroup >> gtViewFor: aView [
	<gtView>
	| view |
	view := aView columnedList
			title: 'Arguments';
			priority: 1;
			items: [ signals ];
			column: 'duration' text: [ :item | item duration ].
	signals first args
		keysDo: [ :each | view column: each text: [ :item | item args at: each ] ].
	^ view
]

{ #category : #accessing }
PBArgumentBeaconSignalGroup >> inject: aValue into: aBlock [
	^signals inject: aValue into: aBlock
]

{ #category : #accessing }
PBArgumentBeaconSignalGroup >> signals: aCollection [
	signals := aCollection
]

{ #category : #accessing }
PBArgumentBeaconSignalGroup >> size [
	^signals size
]
