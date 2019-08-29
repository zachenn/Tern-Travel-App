//
//  DetailViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit
import BEMCheckBox

class DetailViewModel {
	
	// MARK: - Properties
	var didAddDetailCells = false
	var placeItem: PlaceItem? {
		didSet {
			if !didAddDetailCells {
				didAddDetailCells = true
				for i in 0...4 {
					addDetailCellItem(row: i)
				}
			}
		}
	}
	
	var detailCellViewModels: [DetailCellViewModel] = []
	var stateModelController: StateModelController?
	
	var navigationTitle: String {
		return placeItem?.placeTitle ?? ""
	}
	
	// MARK: - Methods
	private func addDetailCellItem(row: Int) {
		
		guard let place = placeItem else { return }
		var detailCellViewModel: DetailCellViewModel
		
		switch row {
		case 0:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .website)
		case 1:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .google)
		case 2:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .phoneNumber)
		case 3:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .completed)
		case 4:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .notes)
		default:
			detailCellViewModel = DetailCellViewModel(place: place, detailCellType: .google)
		}
		
		detailCellViewModels.append(detailCellViewModel)
	}
	
	// MARK: - Cell Selection
	func open(website: String) {
		if let site = URL(string: "\(website)") {
			UIApplication.shared.open(site)
		}
	}
	
	func open(googleSearch: String) {
		if let site = URL(string: "https://www.google.com/search?q=\(googleSearch)") {
			UIApplication.shared.open(site)
		}
	}
	
	func call(phoneNumber: String) {
		if let number = URL(string: "tel://\(phoneNumber)" ) {
			UIApplication.shared.open(number, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
		}
	}
	
	func updateCompletionStatus(with checkBox: BEMCheckBox) {
		
		if placeItem!.completed {
			placeItem?.completed = false
			checkBox.setOn(false, animated: true)
			stateModelController?.update(.completed, with: false, for: placeItem!, from: self)
		} else {
			placeItem?.completed = true
			checkBox.setOn(true, animated: true)
			stateModelController?.update(.completed, with: true, for: placeItem!, from: self)
		}
		
		let number = arc4random_uniform(5)
		switch number {
		case 0:
			checkBox.onAnimationType = BEMAnimationType.bounce
			checkBox.offAnimationType = BEMAnimationType.bounce
			
		case 1:
			checkBox.onAnimationType = BEMAnimationType.stroke
			checkBox.offAnimationType = BEMAnimationType.stroke
			
		case 2:
			checkBox.onAnimationType = BEMAnimationType.fill
			checkBox.offAnimationType = BEMAnimationType.fill
			
		case 3:
			checkBox.onAnimationType = BEMAnimationType.flat
			checkBox.offAnimationType = BEMAnimationType.flat
			
		case 4:
			checkBox.onAnimationType = BEMAnimationType.oneStroke
			checkBox.offAnimationType = BEMAnimationType.oneStroke
			
		default:
			checkBox.onAnimationType = BEMAnimationType.bounce
			checkBox.offAnimationType = BEMAnimationType.bounce
		}
	}
	
	func update <Value> (_ field: PlaceUpdateField, with value: Value) {
		switch field {
		
		case .placeTitle:
			guard let newTitle = value as? String else { return }
			stateModelController?.update(field, with: newTitle, for: placeItem!, from: self)
			
		case .notes:
			guard let notes = value as? String else { return }
			placeItem?.notes = notes
			detailCellViewModels[4].subtitle = notes
			
		default:
			return
		}
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
