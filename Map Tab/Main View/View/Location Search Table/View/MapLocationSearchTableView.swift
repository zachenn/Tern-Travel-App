//
//  MapLocationSearchTableView.swift
//  Tern
//
//  Created by Zach Chen on 6/22/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class MapLocationSearchTableView: StandardTableView {
	
	override func registerTableViewCells() {
		tableView.register(MapLocationSearchCell.self, forCellReuseIdentifier: R.string.localizable.mapLocationSearchTableCellReuseID())
	}
}
