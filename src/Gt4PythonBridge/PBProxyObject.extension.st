Extension { #name : #PBProxyObject }

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> declarativeViews [
	"Answer the views for the receiver"
	| rawViews |

	self viewProxyDo: [ :remoteInspectorProxy |
		rawViews := remoteInspectorProxy getViewsDeclarations collect: [ :viewDictionary |
			| declarativeView |
			declarativeView := GtPhlowViewSpecification fromDictionary: viewDictionary.
			declarativeView initializeFromInspector: remoteInspectorProxy.
			declarativeView ] ].

	^ rawViews
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> filterLocalProxyViews: localViews [ 
	"When showing local views for the object, we remove all views where the method is annotated with gtProxy. Those views will only be shown for the proxy object."
	^ localViews reject: [ :each |
		each definingMethod compiledMethod hasPragmaNamed: #gtProxy ].
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> getViewProxy [
	"Answer a GtViewedProxy on the receiver"

	| gtPackage |
	gtPackage := self application gtPackage => #gt.
	^ self application newCommandFactory
		<< gtPackage import;
		<< (gtPackage => #GtViewedObject callWith: { self });
		sendAndWait
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtActionDownloadFor: anAction [
	<gtAction>

	(#(int str bool float) includes: self remoteClass) 
		ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons down;
		tooltip: 'Download local instance';
		action: [ :button |
			button phlow spawnObject: self unwrapPrimitiveTypes ].
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (self gtRemoteSideInspectorTool
			name: 'Remote';
			playgroundPageStrategy: (LeInspectorPlaygroundProxyClassPageStrategy
				forRemoteProxySide);
			withLabelAndIconAptitude);
		addTool: (super gtDefaultInspectorTool
			name: 'Proxy';
			playgroundPageStrategy: (LeInspectorPlaygroundProxyClassPageStrategy
				forLocalProxySide);
			withLabelAndIconAptitude)
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtLocalViewsFor: aView inContext: aContext [
	| title resultingView |
	title := String streamContents: [ :stream |
				stream
					<< 'Proxy to a(n): ';
					<< (self pythonClass ifNil: [ '<None>' ]) ].
	resultingView := ((aView composite
		views: (self gtViewsInContext: aContext))
		labelled: title).
	^ resultingView
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtMetaFor: aView [
	<gtProxy>
	<gtView>
	^ super gtMetaFor: aView
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtPrintFor: aView [
	<gtProxy>
	<gtView>
	^ super gtPrintFor: aView
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtRawFor: aView [
	<gtProxy>
	<gtView>
	^ super gtRawFor: aView
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtRemoteSideInitialPlaygroundSnippet [
	^ LePythonSnippet new
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtRemoteSideInspectorTool [
	^ GtInspectorTool 
		forObject: self 
		viewSelector: #gtRemoteViewsFor: 
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtRemoteViewSpecificationsFor: aView [
	<gtProxy>
	<gtView>
	^ aView columnedList
		title: 'Remote view specifications';
		priority: 10001;
		items: [ self declarativeViews sorted: #priority ascending];
		column: 'Title' text: [ :aViewAccessor | aViewAccessor title ];
		column: 'Selector' text: [ :aViewAccessor | aViewAccessor methodSelector ];
		column: 'View' text: [ :aViewAccessor | aViewAccessor viewName ];
		column: 'Priority' text: [ :aViewAccessor | aViewAccessor priority ] weight: 0.5;
		column: 'Transport' text: [ :aViewAccessor | aViewAccessor dataTransport ] weight: 0.5;
		send: [ :aDeclarativeView | aDeclarativeView ]
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtRemoteViewsFor: aView [
	"This is the default entry method for retrieving the wrapper view containing all non-proxy views for the object."

	<return: #GtPhlowLabelledView>
	^ GtPhlowLabelledViewBuilder new
		object: self;
		view: aView;
		context: GtPhlowContext new;
		viewsSelector: #gtViewsForRemoteSideInContext:;
		titleComputation: [ String
				streamContents: [ :stream | 
					stream
						<< (pythonClass first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ]);
						<< (pythonClass ifNil: [ '<None>' ]) ] ];
		build
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> gtViewsForRemoteSideInContext: aContext [
	"This collects all views for the current object. This excludes the proxy-specific views (annotated with #gtProxy), and includes all remote views for the object, as well as all custom views defined locally"
 
	| localViews collectedViews |
	
	"Get the views using the super call. 
	This will use #gtView to compute the list of views for the local object."
	localViews := super gtViewsInContext: aContext.
	
	collectedViews := OrderedCollection new
		addAll: (self filterLocalProxyViews: localViews);
		addAll: (self 
			remoteViewsFor: GtPhlowEmptyView new 
			inContext: aContext);
		yourself.
	GtPhlowUtility sortByPriority: collectedViews.
	
	^ collectedViews
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject class >> leProxyTypeForPlaygroundPage [
	^ PBProxyObject
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> remoteClass [
	^ pythonClass
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> remoteViewsFor: aView inContext: aContext [
	"Should be all views, but just get Raw and Print views for now"

	^ [ self declarativeViews collect: [ :declarativeView | declarativeView viewFor: aView ] ]
		on: LanguageLinkServerNotRunningError
		do: [ #() ].

]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> unwrapPrimitiveTypes [
	^ self application commandFactory
		<< self;
		sendAndWait
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> viewProxyDo: aBlock [
	"Evaluate the supplied block ensuring that the receiver is a GtViewedObject"

	| viewProxy |
	viewProxy := pythonClass = #GtViewedObject
			ifTrue: [ self ]
			ifFalse: [ self getViewProxy ].
	^ aBlock value: viewProxy
]
