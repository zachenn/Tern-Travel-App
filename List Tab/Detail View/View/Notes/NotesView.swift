//
//  NotesView.swift
//  Tern
//
//  Created by Zach Chen on 8/17/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class NotesView: UIView {
	
	// MARK: - Properties
	let textView = UITextView()
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configure View
	private func configureUIModifications() {
		backgroundColor = R.color.offWhite()
		textView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func configureView() {
		
		configureUIModifications()
		let marginGuide = layoutMarginsGuide
		
		addSubview(textView)
		textView.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
		textView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
		textView.widthAnchor.constraint(equalTo: marginGuide.widthAnchor).isActive = true
		textView.heightAnchor.constraint(equalTo: marginGuide.heightAnchor).isActive = true
	}
}
