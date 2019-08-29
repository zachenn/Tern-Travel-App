//
//  ListCellViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListCellViewModel {
	
	// MARK: - Initializer
	init(placeItem: PlaceItem) {
		self.placeItem = placeItem
	}
	
	// MARK: - Properties
	var placeItem: PlaceItem?
	
	var placeTitle: String {
		return placeItem?.placeTitle ?? ""
	}
	
	var placeTitleColor: UIColor {
		// FIXME: add in commented code and then add unit test for this property
//		if selectedCollection?.key != masterCollection?.key && (annotationListItem?.completed!)! {
//			return .lightGray
//		}
		return .black
	}
	
	var placeType: Int {
		return placeItem?.placeType ?? 1
	}
	
	var placeAddress: String {
		return placeItem?.placeSubtitle ?? ""
	}
}
