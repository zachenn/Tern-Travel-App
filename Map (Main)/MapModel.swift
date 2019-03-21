//
//  MapModel.swift
//  Tern
//
//  Created by Zach Chen on 4/16/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol HandleMapSearch {
	func addAnnotationItem(placemark: MKPlacemark, mapItem: MKMapItem)
	func addAnnotationItem2(temporaryAnnotation: AnnotationListItem, newDestinationType: Int)
}

class MapModel {
	
	// MARK: LOCATION + MAP METHODS
	
	// update location
	static func updateLocation(locationManager: CLLocationManager) {
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
	}
	
	// request location
	static func requestLocation(locationManager: CLLocationManager) {
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		UserDefaults.standard.set(true, forKey: "requestedLocation")
	}
	
	// map reload
	@objc static func handleMapReload(mapView: MKMapView) {
		mapView.removeAnnotations(mapView.annotations)
		allMapAnnotations.removeAll()
	}
	
	// show all annotations
	static func showAllAnnotations(mapView: MKMapView) {
		mapView.showAnnotations(allMapAnnotations, animated: true)
	}
	
	// MARK: LOAD MAP
	
	// load map
	static func loadPlacesForMap(mapView: MKMapView) {
		if annotationList.isEmpty {
			return
		} else {
			var mapPlaces = [DestinationAnnotation]()
			for place in annotationList {
				
				// update map
				let annotation = DestinationAnnotation(objectUUID: place.objectUUID!, coordinate: CLLocationCoordinate2DMake((place.coordinate?.latitude)!, (place.coordinate?.longitude)!), title: place.annotationTitle!, subtitle: place.annotationSubtitle!, type: DestinationType(rawValue: place.destinationType!)!)
//				let annotation = DestinationAnnotation(annotationListItem: place)
				mapView.addAnnotation(annotation)
				mapPlaces.append(annotation)
			}
			
			allMapAnnotations = mapPlaces
		}
	}
	
	// MARK: DIRECTION METHODS
	
	// GET DIRECTIONS
	static func getDirections(mapItems: [MKMapItem]) {
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
		MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
	}

	// MARK: MAP TYPE METHODS
	
	// handle map type choice
	static func handleMapTypeChoice(mapView: MKMapView, mapType: Int) {
		switch (mapType) {
		case 0:
			mapView.mapType = .standard
		case 1:
			mapView.mapType = .hybrid
		default:
			mapView.mapType = .satellite
		}
	}
	
	// MARK: SHARE METHODS
	
	// share tapped
	static func shareTapped(selectedAnnotation: MKAnnotation) -> [NSString] {
		guard let title = selectedAnnotation.title! else { return [] }
		guard let subtitle = selectedAnnotation.subtitle! else { return [] }
		let appPlug = "Sent through Tern app"
		let shareItem: NSString = "\(title)\n\(subtitle)\n\(appPlug)" as NSString
		let objectsToShare: [NSString] = [shareItem]
		
		return objectsToShare
	}
	
	// MARK: UPDATE METHODS
	
	// handle Annotation Title Update
	static func handleAnnotationTitleUpdate(newTitle: String, editedCoordinate: CLLocationCoordinate2D, editedTitle: String, mapView: MKMapView) {
		
//		// update mapview.annotation (must also conform to NSObject to allow title update
//		if let updateAnnotationTitle = mapView.annotations.filter({ $0.coordinate == editedCoordinate && $0.title! == editedTitle }).first as? DestinationAnnotation {
//			updateAnnotationTitle.title = newTitle
//		}
//
//		// update allAnnotations array
//		if let updateAnnotationsArray = allMapAnnotations.filter({ $0.coordinate == editedCoordinate && $0.title! == editedTitle }).first {
//			updateAnnotationsArray.title = newTitle
//		}
	}
	
	static func setUserDefaults() -> Bool {
		if let key = UserDefaults.standard.value(forKey: "initialCollectionKey"),
			let title = UserDefaults.standard.value(forKey: "initialCollectionTitle"),
			let masterKey = UserDefaults.standard.value(forKey: "masterListKey"),
			let masterTitle = UserDefaults.standard.value(forKey: "masterListTitle") {
			
			selectedCollection = CollectionItem(key: key as! String, collectionListOrder: 0, collectionTitle: title as! String, placesCount: 1)
			masterCollection = CollectionItem(key: masterKey as! String, collectionListOrder: 0, collectionTitle: masterTitle as! String, placesCount: 1)
			
			return true
		} else {
			return false
		}
	}
	
	// MARK: DELETE METHODS
	static func deletePlaceFromMap(mapView: MKMapView) {
		
		// remove from the map
		let mapAnnotations = mapView.annotations as! [DestinationAnnotation]
		if let placeToDelete = mapAnnotations.filter({ $0.objectUUID == uuidToDelete }).first {
			mapView.removeAnnotation(placeToDelete)
		}
		
		// remove from the array of map items
		if let allAnnotationsItemToDelete = allMapAnnotations.index(where: { $0.objectUUID == uuidToDelete }) {
			allMapAnnotations.remove(at: allAnnotationsItemToDelete)
		}
	}
}

// MARK: MAP MENU
extension MapViewController: UIViewControllerTransitioningDelegate {
	@objc func openMapMenu() {
		let mapMenuViewController = MapMenuViewController()
		mapMenuViewController.modalPresentationStyle = .custom
		self.present(mapMenuViewController, animated: true, completion: nil)
	}
}

// MARK: EXTENSION TO ALLOW COORDINATE COMPARISON
extension CLLocationCoordinate2D: Hashable {
	public var hashValue: Int {
		get {
			// Add the hash value of lat and long, taking care of overflow. Here we are muliplying by an aribtrary number. Just in case.
			let latHash = latitude.hashValue&*123
			let longHash = longitude.hashValue
			return latHash &+ longHash
		}
	}
}

// conform to the Equatable protocol.
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
	return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

// MARK: CONNECT LOCATION SEARCH TABLE WITH SEARCH

// this is the delegate method
extension LocationSearchTable {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedItem: MKPlacemark
		let item: MKMapItem
		
		switch indexPath.section {
		case 0:
			selectedItem = matchingExistingItems[indexPath.row].placemark
			item = matchingExistingItems[indexPath.row]
		default:
			selectedItem = matchingItems[indexPath.row].placemark
			item = matchingItems[indexPath.row]
		}
		
		dismiss(animated: true) {
			self.handleMapSearchDelegate?.addAnnotationItem(placemark: selectedItem, mapItem: item)
		}
	}
}

// MARK: ADD NEW ANNOTATION ITEM.
extension MapViewController: HandleMapSearch {
	
	func addAnnotationItem(placemark: MKPlacemark, mapItem: MKMapItem) {
		
		// cache the pin to improve performance
		selectedPin = placemark
		
		// check if it exists to prevent making duplicate, then return out of method if already exists
		let newCoordinate = selectedPin?.coordinate
		let newTitle = selectedPin?.title
		
		if let newAnnotation = mapView.mapView.annotations.filter({ $0.coordinate == newCoordinate && $0.title! == newTitle }).first {
			mapView.mapView.showAnnotations(allMapAnnotations, animated: true)
			mapView.mapView.selectAnnotation(newAnnotation, animated: true)
			return
		}
		
		// create the pin
		
		// ADD THE PIN TO FIREBASE
		
		// Using the current user’s data, create a new AnnotationListItem that is not completed by default
		let objectUUID = UUID().uuidString
		let email = userEmail ?? "anonymous user"
		let listOrder = annotationList.count + 10
		let completed = false
		let title = selectedPin?.name ?? ""
		var subtitle: String?
		let latitude = selectedPin?.coordinate.latitude.debugDescription
		let longitude = selectedPin?.coordinate.longitude.debugDescription
		let annotationCoordinate = FirestoreMethods.getGeoPoint(latitude: Double((selectedPin?.coordinate.latitude)!), longitude: Double((selectedPin?.coordinate.longitude)!))
		let streetNumber = selectedPin?.subThoroughfare ?? ""
		let street = selectedPin?.thoroughfare ?? ""
		let city = selectedPin?.locality ?? "Unknown"
		let state = selectedPin?.administrativeArea ?? "Unknown"
		let country = selectedPin?.country ?? "Unknown"
		let notes = ""
		let destinationType = 0
		let phoneNumber = mapItem.phoneNumber ?? "\(title) Phone Number Unavailable"
		let url = mapItem.url?.absoluteString ?? "\(title) Website Unavailable"
		
		let firstSpace = (selectedPin?.subThoroughfare != nil && selectedPin?.thoroughfare != nil) ? " " : ""
		let comma = (selectedPin?.subThoroughfare != nil || selectedPin?.thoroughfare != nil) && (placemark.subAdministrativeArea != nil || selectedPin?.administrativeArea != nil) ? ", " : ""
		let secondSpace = (selectedPin?.subAdministrativeArea != nil && selectedPin?.administrativeArea != nil) ? " " : ""
		
		if (streetNumber == "" && street == "" && city == "" && state == "") {
			subtitle = ""
		} else {
			subtitle = "\(streetNumber)\(firstSpace)\(street)\(comma)\(city)\(secondSpace)\(state)"
		}
		
		// declare variables
		let annotationListItem = AnnotationListItem(
			objectUUID: objectUUID,
			listOrder: listOrder,
			completed: completed,
			annotationTitle: title,
			annotationSubtitle: subtitle!,
			addedByUserEmail: email,
			addedByUserUid: userUID!,
			mapViewLatitude: latitude!,
			mapViewLongitude: longitude!,
			coordinate: annotationCoordinate,
			streetNumber: streetNumber,
			street: street,
			city: city,
			state: state,
			country: country,
			notes: notes,
			destinationType: destinationType,
			phoneNumber: phoneNumber,
			url: url)
		
//		// Add the annotation under their UID selected collection
//		if selectedCollection?.key != masterCollection?.key {
//
//			// add it to the selected collection
//			FirestoreMethods.addPlaceUnderSelectedCollection(newPlace: annotationListItem.toAny() as! [String: Any]) {
//				NotificationCenter.default.post(name: .placeAddedToCollection, object: nil)
//			}
//
//			// add it to the countries group
//			FirestoreMethods.addPlaceToCountriesCollection(country: country, state: state, city: city, newPlace: annotationListItem.toAny() as! [String: Any])
//
//			// add it to the master collection
//			FirestoreMethods.addPlaceUnderMasterCollection(newPlace: annotationListItem.toAny() as! [String: Any]) {
//				return
//			}
//
//			// check if it exists in the master list
////			if masterCollectionAnnotationListItems.filter({ $0.annotationSubtitle == subtitle }).isEmpty ||
////				masterCollectionAnnotationListItems.filter({ $0.annotationTitle == title}).isEmpty ||
////				(masterCollectionAnnotationListItems.filter({ $0.phoneNumber == phoneNumber }).isEmpty  ) ||
////				(masterCollectionAnnotationListItems.filter({ $0.url == url }).isEmpty ) {
////
////				// add it to the master list if it doesn't exist				FirebaseMethods.addAnnotationToMasterListCollection(annotationListItem: annotationListItem)
////				FirestoreMethods.addPlaceUnderMasterCollection(newPlace: annotationListItem.toAnyObject() as! [String: Any]) {
////					return
////				}
////			}
//
//		} else {
//
//			// selectedCollection = masterCollection
//			FirestoreMethods.addPlaceUnderSelectedCollection(newPlace: annotationListItem.toAny() as! [String: Any]) {
//				NotificationCenter.default.post(name: .placeAddedToCollection, object: nil)
//			}
//		}
		
		// ADD THE PIN TO THE MAPVIEW
		let annotation = DestinationAnnotation(objectUUID: annotationListItem.objectUUID!, coordinate: CLLocationCoordinate2DMake((annotationListItem.coordinate?.latitude)!, (annotationListItem.coordinate?.longitude)!), title: annotationListItem.annotationTitle!, subtitle: annotationListItem.annotationSubtitle!, type: DestinationType(rawValue: annotationListItem.destinationType!)!)
		
//		let annotation = DestinationAnnotation(annotationListItem: annotationListItem)
		
		mapView.mapView.addAnnotation(annotation)
		let span = MKCoordinateSpanMake(0.01, 0.01)
		let region = MKCoordinateRegionMake(annotation.coordinate, span)
		mapView.mapView.setRegion(region, animated: true)
		mapView.mapView.selectAnnotation(annotation, animated: true)
//		allMapAnnotations.append(annotation)
		temporaryMapAnnotations.append(annotation)
		temporaryAnnotationList.append(annotationListItem)
		
		// first annotationItem added success state
		if UserDefaults.standard.value(forKey: "firstAnnotationItemAdded") == nil {
			let firstAnnotationItemAddedSuccessState = FirstAnnotationItemSuccessStateViewController()
			firstAnnotationItemAddedSuccessState.modalPresentationStyle = .custom
			self.present(firstAnnotationItemAddedSuccessState, animated: true, completion: nil)
			
			// set user default
			UserDefaults.standard.set(true, forKey: "firstAnnotationItemAdded")
		}
		
		// reveal showAllAnnotationsButton
		mapView.revealShowAllAnnotationsButton()
	}
	
	func addAnnotationItem2(temporaryAnnotation: AnnotationListItem, newDestinationType: Int) {
		
		// ADD THE PIN TO THE MAPVIEW
		let destinationAnnotation = DestinationAnnotation(objectUUID: temporaryAnnotation.objectUUID!, coordinate: CLLocationCoordinate2DMake((temporaryAnnotation.coordinate?.latitude)!, (temporaryAnnotation.coordinate?.longitude)!), title: temporaryAnnotation.annotationTitle!, subtitle: temporaryAnnotation.annotationSubtitle!, type: DestinationType(rawValue: newDestinationType)!)
		
		mapView.mapView.addAnnotation(destinationAnnotation)
		mapView.mapView.selectAnnotation(destinationAnnotation, animated: true)
		allMapAnnotations.append(destinationAnnotation)
		
		// create permanent annotation
		var permanentAnnotation = temporaryAnnotation
		permanentAnnotation.destinationType = newDestinationType
		
		// Add the annotation under their UID selected collection
		if selectedCollection?.key != masterCollection?.key {
			
			// add it to the selected collection
			FirestoreMethods.addPlaceUnderSelectedCollection(newPlace: permanentAnnotation.toAny() as! [String: Any]) {
				NotificationCenter.default.post(name: .placeAddedToCollection, object: nil)
			}
			
			// add it to the countries group
			FirestoreMethods.addPlaceToCountriesCollection(country: permanentAnnotation.country!, state: permanentAnnotation.state!, city: permanentAnnotation.city!, newPlace: permanentAnnotation.toAny() as! [String: Any])
			
			// add it to the master collection
			FirestoreMethods.addPlaceUnderMasterCollection(newPlace: permanentAnnotation.toAny() as! [String: Any]) {
				return
			}
			
			// check if it exists in the master list
			//			if masterCollectionAnnotationListItems.filter({ $0.annotationSubtitle == subtitle }).isEmpty ||
			//				masterCollectionAnnotationListItems.filter({ $0.annotationTitle == title}).isEmpty ||
			//				(masterCollectionAnnotationListItems.filter({ $0.phoneNumber == phoneNumber }).isEmpty  ) ||
			//				(masterCollectionAnnotationListItems.filter({ $0.url == url }).isEmpty ) {
			//
			//				// add it to the master list if it doesn't exist				FirebaseMethods.addAnnotationToMasterListCollection(annotationListItem: annotationListItem)
			//				FirestoreMethods.addPlaceUnderMasterCollection(newPlace: annotationListItem.toAnyObject() as! [String: Any]) {
			//					return
			//				}
			//			}
			
		} else {
			
			// selectedCollection = masterCollection
			FirestoreMethods.addPlaceUnderSelectedCollection(newPlace: permanentAnnotation.toAny() as! [String: Any]) {
				NotificationCenter.default.post(name: .placeAddedToCollection, object: nil)
			}
		}
	}
}

// MARK: ADD PIN CALLOUT
// wire a button to the pin callout
extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			//return nil so map view draws "blue dot" for standard user location
			return nil
		}
		
		// SWEET TUTOS
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "placeView")

		if annotationView == nil {
			annotationView = DestinationAnnotationView(annotation: annotation, reuseIdentifier: "placeView")
			annotationView?.canShowCallout = false
		} else {
			annotationView?.annotation = annotation
		}

		return annotationView
		
		// ORIGINAL
//		// custom annotationView and callout
//		let annotationView = DestinationAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
//		annotationView.canShowCallout = true
//		let smallSquare = CGSize(width: 30, height: 30)
//
//		// directionsButton
//		let directionsButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: smallSquare))
//		directionsButton.setImage(UIImage(named: "car #079292"), for: .normal)
//		directionsButton.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
//		annotationView.leftCalloutAccessoryView = directionsButton
//
//		// shareButton
//		let shareButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: smallSquare))
//		shareButton.setImage(UIImage(named: "share #black"), for: .normal)
//		shareButton.tintColor = UIColor(red: 0.0275, green: 0.5725, blue: 0.5725, alpha: 0.8) /* #079292 */
//		shareButton.addTarget(self, action: #selector(MapViewController.shareTapped), for: .touchUpInside)
//		annotationView.rightCalloutAccessoryView = shareButton
//
//		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if view.annotation is MKUserLocation {
			return
		}
		
		// SWEET TUTOS
		
		// create the callout view
		let annotation = view.annotation as! DestinationAnnotation

		if annotation.type != .temp {
			let calloutView = PlaceCalloutView()

			calloutView.configureView()
			calloutView.mapViewController = self

			// set the text for the callout view
			calloutView.titleLabel.text = annotation.title
			calloutView.subtitleLabel.text = annotation.subtitle

			// set the location of the callout view
			calloutView.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(calloutView)

			NSLayoutConstraint.activate([
				calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x),
				calloutView.bottomAnchor.constraint(equalTo: view.topAnchor),
				calloutView.widthAnchor.constraint(greaterThanOrEqualToConstant: calloutView.subtitleLabel.frame.width + 20),
//				calloutView.widthAnchor.constraint(equalToConstant: calloutView.buttonBoxWidth),
				calloutView.heightAnchor.constraint(equalToConstant: 45)
				])

			//		mapView.setCenter((view.annotation?.coordinate)!, animated: true)

		} else {

			let calloutView = TemporaryPlaceCalloutView()

			calloutView.configureView()
			calloutView.mapViewController = self

			// set the text for the callout view
//					calloutView.titleLabel.text = annotation.title
//					calloutView.subtitleLabel.text = annotation.subtitle

			// set the location of the callout view
			calloutView.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(calloutView)

			NSLayoutConstraint.activate([
				calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x),
				calloutView.bottomAnchor.constraint(equalTo: view.topAnchor),
				//			calloutView.widthAnchor.constraint(greaterThanOrEqualToConstant: calloutView.subtitleLabel.frame.width + 20),
				calloutView.widthAnchor.constraint(equalToConstant: calloutView.buttonBoxWidth),
				calloutView.heightAnchor.constraint(equalToConstant: 45)
				])

			//		mapView.setCenter((view.annotation?.coordinate)!, animated: true)

		}
		
		
		// ORIGINAL
//		// used for shareTapped
//		let currentlySelectedAnnotation = view.annotation as! DestinationAnnotation
//		self.selectedAnnotation = currentlySelectedAnnotation
//
//		// used for getdirections method
//		let selectedLoc = view.annotation
//		let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
//		let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
//
//		selectedMapItem.name = (view.annotation?.title)!
//
//		self.mapItems = [selectedMapItem]
//		self.selectedPin = selectedPlacemark
//		uuidToDelete = currentlySelectedAnnotation.objectUUID
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		if view.isKind(of: DestinationAnnotationView.self) {
			for subview in view.subviews {
				subview.removeFromSuperview()
			}
		}
	}
}

// you can extract a lot of data from this information (presented are a few examples)
// print(location.altitude)
// print(location.speed)










































