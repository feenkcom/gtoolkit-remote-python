Extension { #name : #PBPromise }

{ #category : #'*Gt4PythonBridge' }
PBPromise >> gtSummaryFor: aView [
	<gtView>

	(value isKindOf: PharoLinkRemoteError) ifFalse: [ ^ aView empty ].
	^ aView forward 
		title: 'Summary';
		priority: 1;
		object: [ value ];
		view: #gtLiveFor:
]
