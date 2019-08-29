//
//  MapLocationSearchTableDataSource.swift
//  Tern
//
//  Created by Zach Chen on 6/22/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class MapLocationSearchTableDataSource: NSObject {
	
	var mapLocationSearchTableViewModel = MapLocationSearchTableViewModel()
	
}

extension MapLocationSearchTableDataSource: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mapLocationSearchTableViewModel.matchingItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.mapLocationSearchTableCellReuseID()) as! MapLocationSearchCell
		cell.mapLocationSearchCellViewModel = MapLocationSearchCellViewModel(mkMapItem: mapLocationSearchTableViewModel.matchingItems[indexPath.row])
		return cell
	}
}
