//
//  ListCellView.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListCellView: UITableViewCell {
	
	// MARK: - Properties
	var listCellViewModel: ListCellViewModel? {
		didSet {
			self.placeTitle.text = listCellViewModel?.placeTitle
			self.placeAddress.text = listCellViewModel?.placeAddress
		}
	}
	
	var placeTitle = UILabel()
	var placeAddress = UILabel()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureUIModifications() {
		placeTitle.customView(title: "", fontName: R.font.robotoRegular.fontName, color: R.color.offBlack()!, style: .cellTitle)
		placeAddress.customView(title: "", fontName: R.font.robotoRegular.fontName, color: .lightGray, style: .cellDescription)
	}
	
	// MARK: - Configure View
	private func configureView() {
		
		configureUIModifications()
		let marginGuide = contentView.layoutMarginsGuide
		
		// place title
		contentView.addSubview(placeTitle)
		placeTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		placeTitle.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
		
		
		// place address
		contentView.addSubview(placeAddress)
		placeAddress.topAnchor.constraint(equalTo: placeTitle.bottomAnchor).isActive = true
		placeAddress.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
		placeAddress.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		
		// other
		self.accessoryType = .detailDisclosureButton
	}
}
