//
//  MapLocationSearchTableViewModel.swift
//  Tern
//
//  Created by Zach Chen on 7/3/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit
import MapKit

// TODO: uses mapView region to prioritize local results. add custom location like yelp. also see how we can improve search

class MapLocationSearchTableViewModel: NSObject {
	
	// MARK: - Properties
	var matchingItems: [MKMapItem] = []
	var mapView: MKMapView? = nil
	var reloadTableViewClosure: () -> () = {}
	
}

// MARK: - UISearchResultsUpdating
extension MapLocationSearchTableViewModel: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		
		guard let mapView = mapView,
			let searchBarText = searchController.searchBar.text else { return }
		
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = searchBarText
		request.region = mapView.region
		
		let search = MKLocalSearch(request: request)
		search.start { response, _ in
			guard let response = response else { return }
			self.matchingItems = response.mapItems
			self.reloadTableViewClosure()
		}
	}
	
}
