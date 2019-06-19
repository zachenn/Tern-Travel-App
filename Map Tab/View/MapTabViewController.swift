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
	
	// CLLocationMangerDelegate
	var locationManager = CLLocationManager()
	
	// MARK: - Lifecycle Methods
	override func loadView() {
		view = MapTabView(frame: UIScreen.main.bounds)
		mapTabView?.mapTabViewController = self
	}
	
	override func viewDidLoad() {
		updateUserLocation()
	}
	
	// MARK: - Button Actions
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
			print("need to add error handling if you see me in the console")
		}
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
			 .restricted:
			break
		default:
			print("need to add error handling if you see me in the console")
		}
	}
}
