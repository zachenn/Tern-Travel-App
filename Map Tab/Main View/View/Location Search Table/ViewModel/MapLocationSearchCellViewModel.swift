//
//  MapLocationSearchTableCellViewModel.swift
//  Tern
//
//  Created by Zach Chen on 7/3/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit
import MapKit

class MapLocationSearchCellViewModel {
	
	// MARK: - Initializers
	init(mkMapItem: MKMapItem) {
		self.mkMapItem = mkMapItem
	}
	
	// MARK: - Properties
	private var mkMapItem: MKMapItem
	
	var placemarkName: String? {
		return mkMapItem.placemark.name
	}
	
	var placemarkAddress: String? {
		return parseAddress(placemarkItem: mkMapItem.placemark)
	}
	
	// MARK: - Methods
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
}
