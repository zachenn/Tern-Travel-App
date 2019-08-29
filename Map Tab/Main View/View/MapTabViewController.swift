//
//  MapTabViewController.swift
//  Tern
//
//  Created by Zach Chen on 6/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTabViewController: UIViewController {
	
	// MARK: - Properties
	var mapTabView: MapTabView! { return self.view as? MapTabView }
	var mapTabViewModel = MapTabViewModel()
	var stateModelController: StateModelController?
	
	// location search
	var resultSearchController: UISearchController? = nil
	let mapLocationSearchTableViewController = MapLocationSearchTableViewController()
	
	// location services
	var locationManager = CLLocationManager()
	
	// MARK: - Lifecycle Methods
	override func loadView() {
		view = MapTabView(frame: UIScreen.main.bounds)
		mapTabView?.mapTabViewController = self
		mapTabView.mapView.delegate = self
		mapTabViewModel.stateModelController = stateModelController
		bindElementsToViewModel()
	}
	
	override func viewDidLoad() {
		updateUserLocation()
		addMapLocationSearchTable()
	}
	
	// MARK: - Button Actions
	@objc func plusButtonDidPress() {
		let mainMenuViewController = MainMenuViewController()
		present(mainMenuViewController, animated: true, completion: nil)
	}
	
	@objc func refreshLocationDidPress() {
		let status = CLLocationManager.authorizationStatus()
		switch status {
		case .authorizedAlways,
			 .authorizedWhenInUse:
			updateUserLocation()
		case .notDetermined:
			let requestLocationViewController = RequestLocationViewController()
			requestLocationViewController.requestLocationDelegate = self
			self.present(requestLocationViewController, animated: true, completion: nil)
		case .denied,
			 .restricted:
			let requestDeniedViewController = RequestLocationDeniedViewController()
			self.present(requestDeniedViewController, animated: true, completion: nil)
		@unknown default:
			print("need to add error handling if you see me in the console, from refreshLocationDidPress in MapTabViewController")
		}
	}
	
	@objc func showAllAnnotationsDidPress() {
		mapTabView.mapView.showAnnotations(mapTabView.mapView.annotations, animated: true)
	}
	
	// MARK: - Setup Methods
	private func addMapLocationSearchTable() {
		
		// set searchResultsController and searchResultsUpdater
		resultSearchController = UISearchController(searchResultsController: mapLocationSearchTableViewController)
		resultSearchController?.searchResultsUpdater = mapLocationSearchTableViewController.mapLocationSearchTableDataSource.mapLocationSearchTableViewModel
		
		// more customization to resultSearchController
		resultSearchController?.hidesNavigationBarDuringPresentation = false
		resultSearchController?.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		
		// connect mapView to viewModel
		mapLocationSearchTableViewController.mapLocationSearchTableDataSource.mapLocationSearchTableViewModel.mapView = self.mapTabView.mapView
		mapLocationSearchTableViewController.mapSearchDelegate = self
		
		// customize the searchbar
		let searchBar = resultSearchController?.searchBar
		searchBar?.sizeToFit()
		searchBar?.placeholder = R.string.localizable.mapSearchbarPlaceholder()
		searchBar?.returnKeyType = .search
		navigationItem.titleView = searchBar
	}
	
	private func bindElementsToViewModel() {
		mapTabViewModel.reloadMapAnnotationsClosure = reloadMapAnnotations(places:)
		mapTabViewModel.deletePlaceItemClosure = deletePlaceAnnotation(key:)
		mapTabViewModel.updatePlaceTitleClosure = update(title:forKey:)
	}
	
	// MARK: - Methods
	private func reloadMapAnnotations(places: [PlaceAnnotation]) {
		mapTabView.mapView.removeAnnotations(mapTabView.mapView.annotations)
		add(placeAnnotations: places)
	}
	
	private func update(title: String, forKey placeKey: String) {
		guard let placeAnnotations = mapTabView.mapView.annotations as? [PlaceAnnotation],
			let index = placeAnnotations.firstIndex(where: { $0.key == placeKey }),
			let placeAnnotation = mapTabView.mapView.annotations[index] as? PlaceAnnotation else { return }
		placeAnnotation.update(title: title)
	}
	
	private func deletePlaceAnnotation(key: String) {
		
		guard let placeAnnotationToDelete = (mapTabView.mapView.annotations.first { (annotation) -> Bool in
			if let placeAnnotation = annotation as? PlaceAnnotation {
				return placeAnnotation.key == key
			}
			return false
		}) else { return }
		
		mapTabView.mapView.removeAnnotation(placeAnnotationToDelete)
	}
}

// MARK: - CLLocationManagerDelegate + RequestLocationDelegate
extension MapTabViewController: CLLocationManagerDelegate, RequestLocationDelegate {
	
	// MARK: Button actions
	@objc internal func requestLocation() {
		mapTabViewModel.requestLocation(locationManager: locationManager)
	}
	
	// MARK: Location Methods
	private func updateUserLocation() {
		locationManager.delegate = self
		mapTabViewModel.updateUserLocation(locationManager: locationManager)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		// zoom in on user location (requires delegate to be set to self to be invoked)
		if let currentLocation = locations.first {
			let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
			let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
			mapTabView?.mapView.setRegion(region, animated: true)
			mapTabView?.mapView.showsUserLocation = true
			locationManager.stopUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		dismiss(animated: true, completion: nil)
		
		switch status {
		case .authorizedWhenInUse,
			 .authorizedAlways:
			updateUserLocation()
		case .denied,
			 .restricted,
			 .notDetermined:
			break
		default:
			print("need to add error handling if you see me in the console, from didChangeAuthorization in MapTabViewController")
		}
	}
}

// MARK: - MapSearch Protocol
extension MapTabViewController: MapSearch {
	
	func add(placeAnnotations: [PlaceAnnotation]) {
		mapTabView.mapView.addAnnotations(placeAnnotations)
	}
	
	func add(mapItem: MKMapItem) {
		
		let annotation = mapTabViewModel.add(mapItem: mapItem)
		
		mapTabView.mapView.addAnnotation(annotation)
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
		
		mapTabView.mapView.setRegion(region, animated: true)
		mapTabView.mapView.selectAnnotation(annotation, animated: true)
	}
}

// MARK: - MapView Delegate
extension MapTabViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation is MKUserLocation { return nil }
		
		var annotationView: StandardAnnotationMarkerView?
		if let annotation = annotation as? PlaceAnnotation {
			annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: R.string.localizable.standardMapMarkerAnnotationReuseID(), for: annotation) as? StandardAnnotationMarkerView
			annotationView?.placeAnnotation = annotation
			annotationView?.placeTypeDidSelectClosure = placeTypeDidSelect(for:)
			annotationView?.removeAnnotationClosure = deletePlaceAnnotation(key:)
			
			annotationView?.directionsButton.addTarget(mapTabViewModel, action: #selector(MapTabViewModel.getDirections), for: .touchUpInside)
			annotationView?.shareButton.addTarget(self, action: #selector(sharePlace), for: .touchUpInside)
		}

		return annotationView
	}
	
	// MARK: Callout methods
	@objc private func sharePlace() {
		let objectsToShare = mapTabViewModel.sharePlace()
		let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activityController, animated: true, completion: nil)
	}
	
	func placeTypeDidSelect(for placeAnnotation: PlaceAnnotation) {
		var place = placeAnnotation.makePlace()
		place.placeType = placeAnnotation.placeType.rawValue
		mapTabViewModel.add(place: place)
	}
}
