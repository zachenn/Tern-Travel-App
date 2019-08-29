//
//  DetailView.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class DetailView: UIView {
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	let layout = UICollectionViewFlowLayout()
	var collectionView: UICollectionView! // UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	var navigationTextField = UITextField()
	
	// MARK: - Configure View
	private func configureUIModifications() {
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		collectionView.backgroundColor = R.color.offWhite()
		collectionView.alwaysBounceVertical = true
		collectionView.register(DetailViewStandardCell.self, forCellWithReuseIdentifier: R.string.localizable.detailViewCellReuseID())
		collectionView.register(CompletedCell.self, forCellWithReuseIdentifier: R.string.localizable.completedCellReuseID())
		collectionView.register(NotesCell.self, forCellWithReuseIdentifier: R.string.localizable.notesCellReuseID())
		
		navigationTextField.sizeToFit()
		navigationTextField.textAlignment = .center
		navigationTextField.returnKeyType = .done
	}
	
	private func configureView() {
		
		configureUIModifications()
		
		let marginGuide = layoutMarginsGuide
		
		addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
		collectionView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
		collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		collectionView.heightAnchor.constraint(equalTo: marginGuide.heightAnchor).isActive = true
	}
	
}
