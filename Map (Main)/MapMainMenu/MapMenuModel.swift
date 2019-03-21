//
//  MapMenuModel.swift
//  Tern
//
//  Created by Zach Chen on 5/8/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import Foundation

class MapMenuModel {
	
	static func mapTypeChoice(sender: UISegmentedControl) {
		
		let mapTypeChoice = sender.selectedSegmentIndex
		let mapTypeDataDict: [String: Any] = ["mapTypeChoice": mapTypeChoice]
		NotificationCenter.default.post(name: .mapTypeChoice, object: nil, userInfo: mapTypeDataDict)
	}
}
