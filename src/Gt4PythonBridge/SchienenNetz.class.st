Class {
	#name : #SchienenNetz,
	#superclass : #PBProxyObject,
	#category : #'Gt4PythonBridge-Core'
}

{ #category : #accessing }
SchienenNetz class >> pythonClass [
	^ #BeaconSignal
]

{ #category : #accessing }
SchienenNetz >> getGeoData [
		^ self newCommandFactory
		<< (self => #get_geo_data_dict callWith: #());
		sendAndWait
]
