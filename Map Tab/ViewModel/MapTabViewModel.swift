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
	
	// MARK: - Location services
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
			print("need to add error handling if you see me in the console")
		}
	}
}

