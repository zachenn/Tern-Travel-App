//
//  ListView.swift
//  Tern
//
//  Created by Zach Chen on 5/19/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit

class ListView: UIView {
	
	// MARK: CREATE VIEW ITEMS
	lazy var tableView = StandardTableView()
	
	// MARK: SET UP VIEW
	private func configureUIModicications() {
		
		// table view
		tableView.register(ListViewCell.self, forCellReuseIdentifier: "listCell")
	}
	
	func configureView() {
	
		configureUIModicications()
		
		// tableView
		addSubview(tableView)
		if #available(iOS 11.0, *) {
			let safeArea = safeAreaLayoutGuide
			tableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
			tableView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
			tableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
			tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor).isActive = true
		} else {
			tableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			tableView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			tableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
			tableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		}
	}
	
	// setup title view
	func headerTitle(title: String, navigationItem: UINavigationItem) {
		let titleLabel = AttributedTitleLabel()
		titleLabel.styleTitleLabel()
		titleLabel.setListTitle(title: title)
		navigationItem.titleView = titleLabel
	}
	
	// search bar
	func setupSearchBar(searchController: UISearchController, viewController: ListViewController) {
		searchController.searchResultsUpdater = viewController
		viewController.definesPresentationContext = true
		searchController.dimsBackgroundDuringPresentation = false
		let searchBar: UISearchBar = searchController.searchBar
		searchBar.placeholder = "Search saved Places"
		searchBar.barTintColor = .white // UIColor(red: 0.0275, green: 0.5725, blue: 0.5725, alpha: 1.0) /* #079292 */
		tableView.tableHeaderView = searchBar
		
		offsetTable()
	}
	
	func offsetTable() {
		let point = CGPoint(x: 0, y: tableView.tableHeaderView!.frame.size.height)
		tableView.setContentOffset(point, animated: false)
	}
	
	// setup Empty State View
	func setupEmptyStateView() {
		let image = UIImage(named: "listBlankState2")
		let view = UIImageView(image: image)
		view.contentMode = .scaleAspectFill
		tableView.backgroundView = view
		tableView.backgroundView?.isHidden = true
		tableView.tableHeaderView?.isHidden = false
		
		// no lines where there aren't any cells
		tableView.tableFooterView = UIView(frame: CGRect.zero)
	}
	
}
