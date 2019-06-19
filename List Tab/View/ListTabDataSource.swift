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
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listTabViewModel.listCellViewModels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.listCellReuseID(), for: indexPath) as! ListCellView
		cell.listCellViewModel = listTabViewModel.listCellViewModels[indexPath.row]
		return cell
	}
}
