Extension { #name : #PBProxyObject }

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> declarativeViews [
	"Answer the views for the receiver"
	| rawViews  |

	self viewProxyDo: [ :remoteInspectorProxy |
		| viewSelectors |
		viewSelectors := remoteInspectorProxy getDeclarativeViewMethodNames.
		rawViews := viewSelectors collect: [ :viewSelector |
			| viewDictionary declarativeView |
			viewDictionary := remoteInspectorProxy getViewDeclaration: viewSelector.
			declarativeView := GtPhlowViewSpecification fromDictionary: viewDictionary.
			declarativeView
				methodSelector: viewSelector;
				initializeFromInspector: remoteInspectorProxy.
			declarativeView ] ].

	^ rawViews
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> getDeclarativeViewFor: viewSelector [
	^ self newCommandFactory
		<< (self => #getDataSource callWith: {viewSelector});
		sendAndWait
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> getDeclarativeViewMethodNames [
	^ self newCommandFactory
		<< (self => #getGtViewMethodNames) call;
		sendAndWait
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> getViewDeclaration: viewSelector [
	^ self newCommandFactory
		<< (self => #getViewDeclaration callWith: {viewSelector});
		sendAndWait
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> getViewProxy [
	"Answer a GtViewedProxy on the receiver"

	^ self application newCommandFactory
		<< (#gtoolkit asP3GI => #gt) import;
		<< (#gtoolkit asP3GI => #gt => #GtViewedObject callWith: {self});
		sendAndWait
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
PBProxyObject >> gtViewsFor: aView inContext: aContext [
	"Add the declarative views from the inspectors object to the inspectors views"

	| resultingView inspectorViews |

	resultingView := self gtLocalViewsFor: aView inContext: aContext.
	inspectorViews := resultingView originalView views.

	"Add the explicitly declarative views from the inspected object"
	inspectorViews addAll: (self 
		remoteViewsFor: aView inContext: aContext).

	"Re-sort by priority"
	inspectorViews := inspectorViews sorted: [ :a :b | a priority < b priority ].
	resultingView originalView views: inspectorViews.
	^resultingView
]

{ #category : #'*Gt4PythonBridge' }
PBProxyObject >> remoteViewsFor: aView inContext: aContext [
	"Should be all views, but just get Raw and Print views for now"

	^ [ self declarativeViews collect: [ :declarativeView | declarativeView viewFor: aView ] ]
		on: LanguageLinkServerNotRunningError
		do: [ #() ].

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
