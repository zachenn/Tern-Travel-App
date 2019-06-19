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
	let placeItem: PlaceItem?
	
	var placeTitle: String {
		return placeItem?.placeTitle ?? ""
	}
	
	var placeTitleColor: UIColor {
		// FIXME: add in commented code
//		if selectedCollection?.key != masterCollection?.key && (annotationListItem?.completed!)! {
//			return .lightGray
//		}
		return .black
	}
	
	var placeAddress: String {
		return placeItem?.placeSubtitle ?? ""
	}
}
