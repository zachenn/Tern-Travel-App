//
//  MapMenuDataSource.swift
//  Tern
//
//  Created by Zach Chen on 5/8/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit

class MapMenuDataSource: NSObject {
	var items = [MapMenuItem]()
	
	override init() {
		super.init()
		items = [
			MapMenuItem(title: "Settings", image: #imageLiteral(resourceName: "settings")),
			MapMenuItem(title: "Give Us Feedback", image: #imageLiteral(resourceName: "postcard")),
			MapMenuItem(title: "Contact Us", image: #imageLiteral(resourceName: "logo small"))
		]
	}
}

extension MapMenuDataSource: UITableViewDataSource {
	
	// number of rows
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	// cell contents
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
		
		let item = items[indexPath.row]
		cell.textLabel?.text = item.title
		cell.imageView?.image = item.image
		cell.backgroundColor = .clear
		
		return cell
	}
	
}
