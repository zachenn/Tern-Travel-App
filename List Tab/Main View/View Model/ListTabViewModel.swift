//
//  ListTabViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabViewModel {
	
	// MARK: - Properties
	var stateModelController: StateModelController?
	private var listCellViewModels: [String: [ListCellViewModel]] = [:]
	private var categories: [String] = []
	
	// FIXME: can use bloom filter here
	private var categorySet: Set <String> = []
	
	var numberOfSections: Int {
		return categories.count
	}
	
	// MARK: - Closures
	var updateDataStateClosure: (DataState) -> () = {_ in }
	var reloadTableViewClosure: () -> () = {}
	var reloadTableViewRow: (String) -> () = {_ in }
	var insertTableViewSection: (Int) -> () = {_ in }
	var insertTableViewRow: (Int) -> () = {_ in }
	var setNavigationTitleClosure: (String) -> () = {_ in }
	var removeSectionClosure: (Int) -> () = {_ in }
	
	// MARK: - Methods
	
	// MARK: For Retrieving Values
	func titleForHeaderIn(section: Int) -> String {
		return categories[section]
	}
	
	func numberOfRowsIn(section: Int) -> Int {
		let category = categories[section]
		return listCellViewModels[category]?.count ?? 0
	}
	
	func listCellViewModel(at indexPath: IndexPath) -> ListCellViewModel? {
		let category = categories[indexPath.section]
		return listCellViewModels[category]?[indexPath.row]
	}
	
	func place(at indexPath: IndexPath) -> PlaceItem? {
		let category = categories[indexPath.section]
		guard let place = listCellViewModels[category]?[indexPath.row].placeItem else { return nil }
		return place
	}
	
	// MARK: For Editing Values
	func load(collection: CollectionItem) {
		let collectionTitle = collection.title
		setNavigationTitleClosure(collectionTitle)
		
		self.listCellViewModels.removeAll()
		for place in collection.placeItems {
			self.add(place: place, insertNewRow: false)
		}
		
		reloadTableViewClosure()
	}
	
	func add(place: PlaceItem, insertNewRow: Bool) {
		
		var insertSection = false
		let listCellViewModel = ListCellViewModel(placeItem: place)
		guard let category = PlaceType(rawValue: place.placeType)?.string() else { return }
		
		if categorySet.contains(category) {
			listCellViewModels[category]?.append(listCellViewModel)
		} else {
			categorySet.insert(category)
			categories.append(category)
			listCellViewModels[category] = [listCellViewModel]
			
			if insertNewRow {
				let section = categories.count - 1
				insertTableViewSection(section)
				insertSection = true
			}
		}
		
		guard let sectionIndex = categories.firstIndex(of: category) else { return }
		
		if insertNewRow && !insertSection { insertTableViewRow(sectionIndex) }
		if categories.count == 1 { updateDataState() }
	}
	
	func update <Value> (_ field: PlaceUpdateField, with value: Value, for place: PlaceItem) {
		
		guard let categoryTitle = PlaceType(rawValue: place.placeType)?.string(),
			let category = listCellViewModels[categoryTitle],
			let index = category.firstIndex(where: { $0.placeItem?.key == place.key }) else { return }
		
		switch field {
		case .placeTitle:
			guard let placeTitle = value as? String else { return }
			listCellViewModels[categoryTitle]?[index].placeItem?.placeTitle = placeTitle
			reloadTableViewRow(place.key)
			
		case .completed:
			guard let completionStatus = value as? Bool else { return }
			listCellViewModels[categoryTitle]?[index].placeItem?.completed = completionStatus
			
		case .notes:
			guard let notes = value as? String else { return }
			listCellViewModels[categoryTitle]?[index].placeItem?.notes = notes
			
		case .placeType:
			guard let placeType = value as? Int else { return }
			listCellViewModels[categoryTitle]?[index].placeItem?.placeType = placeType
			
		default:
			return
		}
	}
	
	func updateDataState() {
		let dataState: DataState = listCellViewModels.count > 0 ? .dataLoaded : .empty
		updateDataStateClosure(dataState)
	}
	
	func reorderListCellViewModel(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		guard let cellViewModel = listCellViewModel(at: sourceIndexPath) else { return }
		let category = categories[sourceIndexPath.section]
		listCellViewModels[category]?.remove(at: sourceIndexPath.row)
		listCellViewModels[category]?.insert(cellViewModel, at: destinationIndexPath.row)
		stateModelController?.selectedCollection?.listOrderNeedsUpdate = true
		
		guard let place = cellViewModel.placeItem else { return }
		stateModelController?.selectedCollection?.placeItems.remove(at: sourceIndexPath.row)
		stateModelController?.selectedCollection?.placeItems.insert(place, at: destinationIndexPath.row)
	}
	
	func remove(at indexPath: IndexPath) {
		
		let category = categories[indexPath.section]
		guard let place = listCellViewModels[category]?[indexPath.row].placeItem else { return }
		listCellViewModels[category]?.remove(at: indexPath.row)
		stateModelController?.delete(place: place, from: self)
		
		if listCellViewModels[category]?.count == 0 {
			categorySet.remove(category)
			categories.remove(at: indexPath.section)
			listCellViewModels.removeValue(forKey: category)
			removeSectionClosure(indexPath.section)
		}
	}
}
