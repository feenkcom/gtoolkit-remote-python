Class {
	#name : #PBArgumentMethodStartSignalGroup,
	#superclass : #Object,
	#instVars : [
		'signals'
	],
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
PBArgumentMethodStartSignalGroup class >> signals: aCollection [
	^self new signals: aCollection 
]

{ #category : #accessing }
PBArgumentMethodStartSignalGroup >> first [
	^signals first
]

{ #category : #accessing }
PBArgumentMethodStartSignalGroup >> gtViewFor: aView [
	<gtView>
	| view |
	view := aView columnedList
			title: 'Arguments';
			priority: 1;
			items: [ signals ];
			column: 'duration' text: [ :item | item duration ].
	signals first startSignal args
		keysDo: [ :each | view column: each text: [ :item | item startSignal args at: each ] ].
	^ view
]

{ #category : #accessing }
PBArgumentMethodStartSignalGroup >> inject: aValue into: aBlock [
	^signals inject: aValue into: aBlock
]

{ #category : #accessing }
PBArgumentMethodStartSignalGroup >> signals: aCollection [
	signals := aCollection
]

{ #category : #accessing }
PBArgumentMethodStartSignalGroup >> size [
	^signals size
]
