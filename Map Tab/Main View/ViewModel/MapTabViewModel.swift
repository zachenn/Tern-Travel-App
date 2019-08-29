//
//  MapTabViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/17/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTabViewModel {
	
	// MARK: - Properties
	var selectedPin: MKPlacemark?
	var stateModelController: StateModelController?
	
	// MARK: - Closures
	var reloadMapAnnotationsClosure: ([PlaceAnnotation]) -> () = {_ in }
	var deletePlaceItemClosure: (String) -> () = {_ in }
	var updatePlaceTitleClosure: (String, String) -> () = {_,_ in }
	
	// MARK: - Methods
	
	// MARK: Location Services
	func requestLocation(locationManager: CLLocationManager) {
		locationManager.requestAlwaysAuthorization()
	}
	
	func updateUserLocation(locationManager: CLLocationManager) {
		let status = CLLocationManager.authorizationStatus()
		
		switch status {
		case .authorizedWhenInUse,
			 .authorizedAlways:
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			DispatchQueue.global(qos: .userInteractive).async {
				locationManager.startUpdatingLocation()
			}
		case .notDetermined,
			 .restricted,
			 .denied:
			break
		@unknown default:
			print("need to add error handling if you see me in the console, from updateUserLocation in MapTabViewModel")
		}
	}
	
	// MARK: Pins
	func load(collection: CollectionItem) {
		
		let placeAnnotations = collection.placeItems.map { (place) -> PlaceAnnotation in
			return PlaceAnnotation(with: place)
		}
		reloadMapAnnotationsClosure(placeAnnotations)
	}
	
	func add(mapItem: MKMapItem) -> MKAnnotation {
		
		// cache the pin
		selectedPin = mapItem.placemark
		
		// FIXME: make me safe
		// create a new PlaceItem
		let key = UUID().uuidString
		let listOrder = 100
		let completed = false
		let placeTitle = selectedPin?.name ?? "change me"
		let placeSubtitle = parseAddress(placemarkItem: selectedPin!)
		let addedByUserEmail = "email"
		let addedByUserUid = "change me uid"
		let mapViewLatitude = Double((selectedPin?.coordinate.latitude)!)
		let mapViewLongitude = Double((selectedPin?.coordinate.longitude)!)
		let streetNumber = selectedPin?.subThoroughfare
		let streetAddress = selectedPin?.thoroughfare
		let city = selectedPin?.subAdministrativeArea
		let state = selectedPin?.administrativeArea
		let country = selectedPin?.country
		let notes = ""
		let placeType = PlaceType.temp.rawValue
		let phoneNumber = mapItem.phoneNumber ?? "\(placeTitle) Phone Number Unavailable"
		let url = mapItem.url?.absoluteString ?? "\(placeTitle) Website Unavailable"
		
		var placeItem = PlaceItem(key: key, listOrder: listOrder, completed: completed, placeTitle: placeTitle, placeSubtitle: placeSubtitle, addedByUserEmail: addedByUserEmail, addedByUserUid: addedByUserUid, mapViewLatitude: mapViewLatitude, mapViewLongitude: mapViewLongitude, streetNumber: streetNumber!, street: streetAddress!, city: city!, state: state!, country: country!, notes: notes, placeType: placeType, phoneNumber: phoneNumber, url: url)
		
		// add it to the stateModelController
//		stateModelController?.add(place: &placeItem, from: self)
		
		// create the map annotation for the mapView
		let placeAnnotation = PlaceAnnotation(with: placeItem)
		return placeAnnotation
	}
	
	func add(place: PlaceItem) {
		var newPlace = place
		stateModelController?.add(place: &newPlace, from: self)
	}
	
	private func parseAddress(placemarkItem: MKPlacemark) -> String {
		
		let streetNumber = placemarkItem.subThoroughfare
		let streetAddress = placemarkItem.thoroughfare
		let city = placemarkItem.subAdministrativeArea
		let state = placemarkItem.administrativeArea
		
		let firstSpace = (streetNumber != nil && streetAddress != nil) ? " " : ""
		let comma = (streetNumber != nil || streetAddress != nil) && (city != nil || state != nil) ? ", " : ""
		let secondSpace = (city != nil && state != nil) ? " " : ""
		
		let addressLine = String(format:"%@%@%@%@%@%@%@",
								 streetNumber ?? "", firstSpace, streetAddress ?? "", comma, city ?? "", secondSpace, state ?? ""
		)
		
		return addressLine
	}
	
	func update <Value> (_ field: PlaceUpdateField, with value: Value, for place: PlaceItem) {
		switch field {
		case .placeTitle:
			guard let title = value as? String else { return }
			updatePlaceTitleClosure(title, place.key)
		case .placeType:
			let placeType = place.placeType
			stateModelController?.update(field, with: placeType, for: place, from: self)
		default:
			return
		}
	}
	
	func delete(_ place: PlaceItem) {
		deletePlaceItemClosure(place.key)
	}
	
	// MARK: Callout Methods
	@objc func getDirections() {
		if let selectedPin = selectedPin {
			let mapItem = MKMapItem(placemark: selectedPin)
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
			mapItem.name = selectedPin.name
			mapItem.openInMaps(launchOptions: launchOptions)
		}
	}
	
	@objc func sharePlace() -> [String] {
		var objectsToShare: [String] = []
		if let title = selectedPin?.title {
			objectsToShare = ["\(title)"]
		}
		return objectsToShare
	}
}

