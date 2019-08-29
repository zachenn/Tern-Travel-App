//
//  ListTabDataSource.swift
//  Tern
//
//  Created by Zach Chen on 6/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabDataSource: NSObject {
	
	var listTabViewModel = ListTabViewModel()
	
}

extension ListTabDataSource: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return listTabViewModel.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return listTabViewModel.titleForHeaderIn(section: section)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listTabViewModel.numberOfRowsIn(section: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.listCellReuseID(), for: indexPath) as! ListCellView
		cell.listCellViewModel = listTabViewModel.listCellViewModel(at: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		listTabViewModel.reorderListCellViewModel(from: sourceIndexPath, to: destinationIndexPath)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		switch editingStyle {
		case .delete:
			listTabViewModel.remove(at: indexPath)
			tableView.deleteRows(at: [indexPath], with: .fade)
			listTabViewModel.updateDataState()
		default:
			print("fix me: commit editingStyle in ListTabDataSource")
		}
	}
}
