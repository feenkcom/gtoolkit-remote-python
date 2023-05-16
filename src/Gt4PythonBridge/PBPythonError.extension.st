Extension { #name : #PBPythonError }

{ #category : #'*Gt4PythonBridge' }
PBPythonError >> gtLiveFor: aView [
	<gtView>

	trace ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Summary';
		priority: 1;
		text: [ self summaryText ]
]

{ #category : #'*Gt4PythonBridge' }
PBPythonError >> gtPharoStackFor: aView [
	<gtView>
	
	(signalContext isNil or: [ self signalerContext isNil ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Pharo stack';
		priority: 10;
		object: [ self signalerContext ];
		view: #gtStackFor:
]
