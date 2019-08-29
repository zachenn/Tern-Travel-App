//
//  MapLocationSearchTable.swift
//  Tern
//
//  Created by Zach Chen on 6/22/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class MapLocationSearchTableViewController: UIViewController {
	
	// MARK: - Properties
	var mapLocationSearchTableView: MapLocationSearchTableView! { return self.view as? MapLocationSearchTableView }
	var mapLocationSearchTableDataSource = MapLocationSearchTableDataSource()
	var mapSearchDelegate: MapSearch?

	// MARK: - Lifecycle Methods
	override func loadView() {
		view = MapLocationSearchTableView(frame: UIScreen.main.bounds)
		mapLocationSearchTableView.tableView.delegate = self
		mapLocationSearchTableView.tableView.dataSource = mapLocationSearchTableDataSource
		mapLocationSearchTableDataSource.mapLocationSearchTableViewModel.reloadTableViewClosure = mapLocationSearchTableView.tableView.reloadData
	}
}

// MARK: - Table View Delegate
extension MapLocationSearchTableViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedItem = mapLocationSearchTableDataSource.mapLocationSearchTableViewModel.matchingItems[indexPath.row]
		mapSearchDelegate?.add(mapItem: selectedItem)
		dismiss(animated: true, completion: nil)
	}
}

