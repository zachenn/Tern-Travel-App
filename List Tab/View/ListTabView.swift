//
//  ListTabView.swift
//  Tern
//
//  Created by Zach Chen on 6/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabView: UIView {
	
	// MARK: - Initializer
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Create UI Objects
	var listTableView = UITableView()
	var backgroundView = UIImageView(image: R.image.listBlankState())
	
	// MARK: - Configure View
	private func configureUIModifications() {
		
		backgroundColor = R.color.offWhite()
		listTableView.standard()
		listTableView.register(ListCellView.self, forCellReuseIdentifier: R.string.localizable.listCellReuseID())
		
		backgroundView.contentMode = .scaleAspectFit
		listTableView.backgroundView = backgroundView
		listTableView.backgroundView?.isHidden = true
	}
	
	private func configureView() {
		
		configureUIModifications()
		
		addSubview(listTableView)
		listTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		listTableView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		listTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		listTableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
	}
}
