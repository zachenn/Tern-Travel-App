//
//  ListTabViewModel.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabViewModel {
	
	// TODO: - Add an observer or delegate method or reactive swift to be notified when a new annotationItem is added which will call addListCellViewModel. This can be from a Firestore observer + an offline observer
	
	// MARK: - Properties
	var listCellViewModels: [ListCellViewModel] = []
	
		// FIXME: add multiple sections
	var sections = 1
	
	var editButton: UIBarButtonItem?
	var collectionButton: UIBarButtonItem?
	var listTabViewController: ListTabViewController? {
		didSet {
			editButton = UIBarButtonItem(title: R.string.localizable.edit(), style: .plain, target: listTabViewController, action: #selector(ListTabViewController.editButtonDidPress))
			collectionButton = UIBarButtonItem(title: R.string.localizable.collections(), style: .plain, target: listTabViewController, action: #selector(ListTabViewController.collectionsDidPress))
		}
	}
	
	// MARK: - Methods
	func add(listCellViewModel: ListCellViewModel) {
		listCellViewModels.append(listCellViewModel)
	}
	
	func dataState() -> DataState {
		return listCellViewModels.count > 0 ? .dataLoaded : .empty
	}
}
