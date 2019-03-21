//
//  MapViewController.swift
//  mapApp Official
//
//  Created by Zach Chen on 8/16/17.
//  Copyright © 2017 Zach Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
	
	//imported MapKit, and CoreLocation. Added Privacy.. in info.plist. turned on maps in capabilities.
	
	// MARK: PROPERTIES
	var resultSearchController: UISearchController? = nil
	var selectedPin: MKPlacemark? = nil
	var locationManager = CLLocationManager()
	var mapItems = [MKMapItem]()
	var selectedAnnotation: MKAnnotation!
	var authorizationStatus: Bool?
	
	// MARK: SET UP VIEW
	var mapView: MapView! { return self.view as? MapView }
	
	override func loadView() {
		view = MapView(frame: UIScreen.main.bounds)
		mapView.mapViewController = self
		mapView.configureButtonView()
	}
	
	// MARK: VIEWDIDLOAD
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setInitialUserDefaults()
		
		// set up location search table
		setupLocationSearchTable()

		// zoom into user location
		if UserDefaults.standard.value(forKey: "requestedLocation") != nil {
			locationManager.delegate = self
			MapModel.updateLocation(locationManager: locationManager)
		}

		// activate notification observers
		handleNotificationObservers()
	}
	
	// MARK: SETUP FUNCTIONS
	func setInitialUserDefaults() {
		
		// set initial userDefaults but guard against none
		if MapModel.setUserDefaults() {
			
			// load annotations for the map
			FirestoreMethods.loadCollectionItems {
				MapModel.loadPlacesForMap(mapView: self.mapView.mapView)
			}
		}
	}
	
	func setupLocationSearchTable() {
		
		// set up the search results table
		let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
		
		resultSearchController = UISearchController(searchResultsController: locationSearchTable)
		mapView.setupLocationSearchTable(locationSearchTable: locationSearchTable, resultSearchController: resultSearchController!, mapView: mapView.mapView, delegate: self)
		
	}
	
	func handleNotificationObservers() {
		
		// collection has changed. reload the map with new collection items
		NotificationCenter.default.addObserver(self, selector: #selector(handleMapReload), name: .mapReload, object: nil)

		// user has changed the title of an annotation
		NotificationCenter.default.addObserver(self, selector: #selector(handleAnnotationTitleUpdate(_:)), name: .updateAnnotationTitle, object: nil)
		
		// user has chosen a different map type
		NotificationCenter.default.addObserver(self, selector: #selector(handleMapTypeChoice(_:)), name: .mapTypeChoice, object: nil)
		
		// user is exiting the main menu
		NotificationCenter.default.addObserver(self, selector: #selector(revivePlusButton), name: .reviveMapTypeButton, object: nil)
		
		// user has selected the refresh location button for the first time
		NotificationCenter.default.addObserver(self, selector: #selector(requestLocation), name: .requestLocation, object: nil)
		
		// an item has been deleted from the collection. delete it from the mapView
		NotificationCenter.default.addObserver(self, selector: #selector(deletePlaceFromMap), name: .placeDeletedFromCollection, object: nil)
	}
	
	@objc func deletePlaceFromMap() {
		MapModel.deletePlaceFromMap(mapView: self.mapView.mapView)
	}

	// MARK: LOCATION FUNCTIONS
	func locationManager(_ _manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			self.locationManager.startUpdatingLocation()
	//		self.locationManager.startUpdatingHeading()
	//		self.updateHeadingRotation()
			dismiss(animated: true, completion: nil)
		}
		
		if status == .denied {
			authorizationStatus = false
		}
	}
	
	// zoom in on user location
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let currentLocation = locations.first {
			let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
			let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation.coordinate, span)
			mapView.mapView.setRegion(region, animated: true)
			mapView.mapView.showsUserLocation = true
			self.locationManager.stopUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error: (error)")
	}

	// MARK: BUTTON ACTIONS
	@objc func requestLocation() {
		locationManager.delegate = self
		MapModel.requestLocation(locationManager: locationManager)
	}
	
	@objc func handleShowAllAnnotations() {
		MapModel.showAllAnnotations(mapView: mapView.mapView)
		
		// hide onboarding callout if showing
		mapView.hideOnboardingCallout(view: view)

	}
	
	// MARK: CALLOUT BUBBLE BUTTON ACTIONS
		// get directions
		// method (called in MKMapViewDelegate extension)
	@objc func getDirections() {
		MapModel.getDirections(mapItems: mapItems)
	}

	
	// share
	@objc func shareTapped() {
		let objectsToShare: [NSString] = MapModel.shareTapped(selectedAnnotation: selectedAnnotation)
		let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
	// remove temporary annotation
	@objc func removeTemporaryAnnotation() {
		mapView.mapView.removeAnnotation(selectedAnnotation)
		if let placeToRemoveFromMap = temporaryAnnotationList.index(where: { $0.objectUUID == uuidToDelete }) {
			temporaryAnnotationList.remove(at: placeToRemoveFromMap)
		}
	}
	
	// permanently add annotation
	@objc func addNewAnnotation() {

		// add the new annotation
		if let newAnnotation = temporaryAnnotationList.filter({ $0.objectUUID == uuidToDelete}).first {
			
			// remove the temporary annotation
			self.removeTemporaryAnnotation()
			
			// add the permanent annotation
			addAnnotationItem2(temporaryAnnotation: newAnnotation, newDestinationType: 1)
		}

	}
	
	// MARK: NOTIFICATION FUNCTIONS
	
	// map Reload
	@objc func handleMapReload() {
		MapModel.handleMapReload(mapView: self.mapView.mapView)
		MapModel.loadPlacesForMap(mapView: self.mapView.mapView)
	}
	
	// update Annotation Title
	@objc func handleAnnotationTitleUpdate(_ notification: NSNotification) {
		if let newTitle = notification.userInfo?["newAnnotationTitle"] as? String,
			let editedCoordinate = notification.userInfo?["editedCoordinate"] as? CLLocationCoordinate2D,
			let editedTitle = notification.userInfo?["editedTitle"] as? String {
			
			MapModel.handleAnnotationTitleUpdate(newTitle: newTitle, editedCoordinate: editedCoordinate, editedTitle: editedTitle, mapView: mapView.mapView)
			
		}
	}
	
	// refresh location
	@objc func handleRefreshLocation() {
		if UserDefaults.standard.value(forKey: "requestedLocation") != nil {
			self.locationManager.startUpdatingLocation()
			
			if authorizationStatus == false {
				let requestLocationDeniedViewController = RequestLocationDeniedViewController()
				requestLocationDeniedViewController.modalPresentationStyle = .custom
				self.present(requestLocationDeniedViewController, animated: true, completion: nil)
			}
			
		} else {
			let requestLocationViewController = RequestLocationViewController()
			requestLocationViewController.modalPresentationStyle = .custom
			self.present(requestLocationViewController, animated: true, completion: nil)
		}
	}
	
	// change map type
	@objc func handleMapTypeChoice(_ notification: NSNotification) {
		
		if let mapType = notification.userInfo?["mapTypeChoice"] as? Int {
			MapModel.handleMapTypeChoice(mapView: mapView.mapView, mapType: mapType)
		}
	}
	
	// animate plus button
	@objc func revivePlusButton() {
		mapView.revivePlusButton()
	}
	
	// MARK: HANDLE SIGN OUT
	@objc func signOut() {
		if AuthProvider.Instance.signOut() {
			let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
			self.present(registerViewController, animated: true, completion: nil)
		}
	}

	
	// MARK: DID RECEIVE MEMORY WARNING
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	
	// MARK: OTHER
	
	//Off the top of my head, if you're speaking of the search bar cancel button. Implement the UISearchBarDelegate function, searchBarCancelButtonClicked(:), calling navigationItem.titleView = nil in that function. This should remove the search bar if that's what you meant by "remove it". For normal search bar functionality, also ensure you implement searchBarSearchButtonClicked(:) adding searchBar.resignFirstResponder() to remove keyboard when search button is clicked (or started via return key press)
	
	// MARK: CLEAR SEARCH BAR AFTER SELECTING ITEM
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		//searchBar.text = ""
	}
	
	//	// MARK: HEADING VIEW
	//	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
	//		if views.last?.annotation is MKUserLocation {
	//			addHeadingViewToAnnotationView(annotationView: views.last!)
	//		}
	//	}
	//
	//	var headingImageView: UIImageView?
	//
	//	func addHeadingViewToAnnotationView(annotationView: MKAnnotationView) {
	//		if headingImageView == nil {
	//			if let image = UIImage(named: "heading arrow #079292") {
	//				headingImageView = UIImageView(image: image)
	//				headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - image.size.width)/2, y: (annotationView.frame.size.height - image.size.height)/2, width: image.size.width, height: image.size.height)
	//				annotationView.insertSubview(headingImageView!, at: 0)
	//			}
	//		}
	//	}
	//
	//	func updateHeadingRotation() {
	//		if let heading = userHeading,
	//			let headingImageView = headingImageView {
	//				headingImageView.isHidden = false
	//				let rotation = CGFloat(heading/180 * .pi)
	//				headingImageView.transform = CGAffineTransform(rotationAngle: rotation)
	//			}
	//		}
}



































