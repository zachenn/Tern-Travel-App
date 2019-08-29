//
//  DetailViewDataSource.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class DetailViewDataSource: NSObject {
	
	var detailViewModel = DetailViewModel()
	
}

extension DetailViewDataSource: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return detailViewModel.detailCellViewModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellType = detailViewModel.detailCellViewModels[indexPath.row].detailCellType
		
		switch cellType {
		case .website,
			 .google,
			 .phoneNumber:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.string.localizable.detailViewCellReuseID(), for: indexPath) as! DetailViewStandardCell
			cell.detailCellViewModel = detailViewModel.detailCellViewModels[indexPath.row]
			return cell
		case .completed:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.string.localizable.completedCellReuseID(), for: indexPath) as! CompletedCell
			cell.detailCellViewModel = detailViewModel.detailCellViewModels[indexPath.row]
			return cell
		case .notes:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.string.localizable.notesCellReuseID(), for: indexPath) as! NotesCell
			cell.detailCellViewModel = detailViewModel.detailCellViewModels[indexPath.row]
			return cell
		}
	}
}
