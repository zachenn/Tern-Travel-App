//
//  ListModel.swift
//  Tern
//
//  Created by Zach Chen on 5/19/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit
import MapKit

class ListModel {
	
	// MARK: TABLE VIEW
	
	// check for empty state
	static func checkForEmptyState(tableView: UITableView, navigationItem: UINavigationItem, button: UIBarButtonItem) {
		
		// refresh the table
		tableView.reloadData()
		
		// check for empty state
		if annotationList.count != 0 {
			
			tableView.backgroundView?.isHidden = true
			tableView.tableHeaderView?.isHidden = false
			
			if selectedCollection?.key != masterCollection?.key {
				navigationItem.rightBarButtonItem = button
			} else {
				navigationItem.rightBarButtonItem = nil
			}
			
		} else {
			tableView.backgroundView?.isHidden = false
			tableView.tableHeaderView?.isHidden = true
		}
	}
	
	// MARK: DELETING ITEMS
	
	// delete item from collection
	static func deleteItemFromCollection(indexPath: IndexPath, searchController: UISearchController, tableView: UITableView) {
		
		// extract information
		let annotationItem: AnnotationListItem
		if isFiltering(searchController: searchController) {
			annotationItem = filteredAnnotationList[indexPath.row]
			
			let key = annotationItem.key
			let indexToDelete = annotationList.index(where: { (item) -> Bool in
				item.key == key
			})
			
			// remove from list and table
			filteredAnnotationList.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			annotationList.remove(at: indexToDelete!)
			
		} else {
			
			annotationItem = annotationList[indexPath.row]
			
			// remove from list and table
			annotationList.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			
		}
		
		uuidToDelete = annotationItem.objectUUID
		
		// remove from Firestore
		FirestoreMethods.deletePlaceFromCollection(placeItem: annotationItem)
	}
	
	// delete place from all collections
	static func deletePlaceFromAllCollections() {
		FirestoreMethods.deletePlaceFromAllCollections {
			return
		}
	}
	
	// MARK: MANAGE SEARCH
	
	// searchBar is Empty
	static func searchBarIsEmpty(searchController: UISearchController) -> Bool {
		
		// returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	// is Filtering
	static func isFiltering(searchController: UISearchController) -> Bool {
		return searchController.isActive && !searchBarIsEmpty(searchController: searchController)
	}
	
	// MARK: DIRECTIONS
	static func getDirections(mapItems: [MKMapItem]) {
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
		MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
	}
}
