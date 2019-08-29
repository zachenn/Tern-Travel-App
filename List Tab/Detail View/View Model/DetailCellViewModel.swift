//
//  DetailCellViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class DetailCellViewModel {
	
	enum DetailCellType: String {
		case website
		case google
		case phoneNumber
		case completed
		case notes
	}
	
	// MARK: - Properties
	var title: String
	var subtitle: String
	var detailCellType: DetailCellType
	var completionStatus: Bool {
		return place.completed
	}
	private var place: PlaceItem
	
	// MARK: - Initializers
	init(place: PlaceItem, detailCellType: DetailCellType) {
		self.place = place
		self.detailCellType = detailCellType
		
		switch detailCellType {
		case .website:
			self.title = R.string.localizable.website()
			self.subtitle = place.url
		case .google:
			self.title = R.string.localizable.viewOnGoogle()
			self.subtitle = "\(R.string.localizable.search()) \(place.placeTitle) \(R.string.localizable.onGoogle())"
		case .phoneNumber:
			self.title = R.string.localizable.phoneNumber()
			self.subtitle = place.phoneNumber
		case .completed:
			self.title = R.string.localizable.completed()
			self.subtitle = ""
		case .notes:
			self.title = R.string.localizable.notes()
			
			var notes = place.notes
			if notes.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
				notes = R.string.localizable.notesPlaceholderText()
			}
			self.subtitle = notes
		}
	}
}
