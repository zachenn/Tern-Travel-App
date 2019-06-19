//
//  ListTabViewController.swift
//  Tern
//
//  Created by Zach Chen on 6/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabViewController: UIViewController {
	
	// MARK: - Properties
	var listTabView: ListTabView! { return self.view as? ListTabView }
	var listTabDataSource = ListTabDataSource()
	var dataState: DataState = .empty {
		didSet {
			switch dataState {
			case .empty:
				self.listTabView.listTableView.backgroundView?.isHidden = false
				self.listTabView.listTableView.tableHeaderView?.isHidden = true
				self.navigationItem.rightBarButtonItem = nil
				self.listTabView.listTableView.reloadData()
			case .dataLoaded:
				self.listTabView.listTableView.backgroundView?.isHidden = true
				self.listTabView.listTableView.tableHeaderView?.isHidden = false
				self.navigationItem.rightBarButtonItem = listTabDataSource.listTabViewModel.editButton
				self.listTabView.listTableView.reloadData()
			}
			
		}
	}
	
	// MARK: - Lifecycle Methods
	override func loadView() {
		view = ListTabView(frame: UIScreen.main.bounds)
		listTabView.listTableView.delegate = self
		listTabView.listTableView.dataSource = listTabDataSource
		listTabDataSource.listTabViewModel.listTabViewController = self
	}
	
	override func viewDidLoad() {
		addDummyData()
		loadViewItems()
	}
	
	// FIXME: remove
	private func addDummyData() {
		let p1 = PlaceItem(key: "1", objectUUID: "1", listOrder: 1, completed: true, placeTitle: "Apple", placeSubtitle: "Title", addedByUserEmail: "email", addedByUserUid: "uid", mapViewLatitude: "2", mapViewLongitude: "2", streetNumber: "1", street: "1", city: "1", state: "CA", country: "USA", notes: "notes", destinationType: 1, phoneNumber: "93", url: "url")
		let p2 = PlaceItem(key: "1", objectUUID: "1", listOrder: 1, completed: true, placeTitle: "Banana", placeSubtitle: "Title", addedByUserEmail: "email", addedByUserUid: "uid", mapViewLatitude: "2", mapViewLongitude: "2", streetNumber: "1", street: "1", city: "1", state: "CA", country: "USA", notes: "notes", destinationType: 1, phoneNumber: "93", url: "url")
		let p3 = PlaceItem(key: "1", objectUUID: "1", listOrder: 1, completed: true, placeTitle: "Grape", placeSubtitle: "Title", addedByUserEmail: "email", addedByUserUid: "uid", mapViewLatitude: "2", mapViewLongitude: "2", streetNumber: "1", street: "1", city: "1", state: "CA", country: "USA", notes: "notes", destinationType: 1, phoneNumber: "93", url: "url")
		
		listTabDataSource.listTabViewModel.add(listCellViewModel: ListCellViewModel(placeItem: p1))
		listTabDataSource.listTabViewModel.add(listCellViewModel: ListCellViewModel(placeItem: p2))
		listTabDataSource.listTabViewModel.add(listCellViewModel: ListCellViewModel(placeItem: p3))
	}
	
	// MARK: - Setup Methods
	private func loadViewItems() {
		navigationItem.leftBarButtonItem = listTabDataSource.listTabViewModel.collectionButton
		dataState = listTabDataSource.listTabViewModel.dataState()
	}
	
	// MARK: - Navigation Button Actions
	@objc func editButtonDidPress() {
		listTabView.listTableView.setEditing(!listTabView.listTableView.isEditing, animated: true)
		navigationItem.rightBarButtonItem?.title = listTabView.listTableView.isEditing ? R.string.localizable.done() : R.string.localizable.edit()
	}
	
	@objc func collectionsDidPress() {
		// TODO: give me something to do!
	}
}

// MARK: - TableViewDelegate
extension ListTabViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailViewController = DetailViewController()
		detailViewController.detailViewDataSource.detailViewModel.placeItem = listTabDataSource.listTabViewModel.listCellViewModels[indexPath.row].placeItem
		navigationController?.pushViewController(detailViewController, animated: true)
	}
}
