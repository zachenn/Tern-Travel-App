//
//  ListDataSource.swift
//  Tern
//
//  Created by Zach Chen on 5/20/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit

class ListDataSource: NSObject {
	
}

// MARK: LIST DATA SOURCE
extension ListViewController: UITableViewDataSource {
	
	// number of sections
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// number of rows in section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering() {
			return filteredAnnotationList.count
		}
		return annotationList.count
	}
	
	// cell contents	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// design cell
		let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
		let annotatedItem: AnnotationListItem
		
		// grab information
		if isFiltering() {
			annotatedItem = filteredAnnotationList[indexPath.row]
		} else {
			annotatedItem = annotationList[indexPath.row]
		}
		
		// check if we are displaying the master list
		if selectedCollection?.key != masterCollection?.key {
			
			// check completed state
			if annotatedItem.completed! {
				cell.textLabel?.textColor = UIColor.lightGray
			}
		}
		
		// populate cell
		cell.textLabel?.text = annotatedItem.annotationTitle
		cell.detailTextLabel?.text = annotatedItem.annotationSubtitle
		return cell
	}
}
