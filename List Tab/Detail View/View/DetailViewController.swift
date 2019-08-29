//
//  DetailViewController.swift
//  Tern
//
//  Created by Zach Chen on 6/18/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	// MARK: - Properties
	var detailView: DetailView! { return self.view as? DetailView }
	var detailViewDataSource = DetailViewDataSource()
	private var notesIndexPath: IndexPath?
	
	// MARK: - Lifecycle Methods
	override func loadView() {
		view = DetailView(frame: UIScreen.main.bounds)
		detailView.collectionView.delegate = self
		detailView.collectionView.dataSource = detailViewDataSource
	}
	
	override func viewDidLoad() {
		setupNavigationItems()
	}
	
	// MARK: - Setup Methods
	private func setupNavigationItems() {
		detailView.navigationTextField.text = detailViewDataSource.detailViewModel.navigationTitle
		detailView.navigationTextField.delegate = self
		navigationItem.titleView = detailView.navigationTextField
		navigationItem.largeTitleDisplayMode = .never
	}
	
	// MARK: - Methods
	private func update(notes: String) {
		detailViewDataSource.detailViewModel.update(.notes, with: notes)
		guard let indexPath = notesIndexPath else { return }
		detailView.collectionView.reloadItems(at: [indexPath])
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
	
	// cell size
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let detailCellViewModel = detailViewDataSource.detailViewModel.detailCellViewModels[indexPath.item]
		let approximateWidth = view.frame.width
		let size = CGSize(width: approximateWidth, height: 1000)
		let attributes = [NSAttributedString.Key.font: UIFont(name: R.font.robotoRegular.fontName, size: 12)]
		let estimatedFrame = NSString(string: detailCellViewModel.subtitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
		return CGSize(width: view.frame.width, height: estimatedFrame.height + 40)

	}

	// spacing between each row in the layout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let detailCellViewModel = self.detailViewDataSource.detailViewModel.detailCellViewModels[indexPath.row] as DetailCellViewModel
		
		switch detailCellViewModel.detailCellType {
		case .website:
			detailViewDataSource.detailViewModel.open(website: detailCellViewModel.subtitle)
		case .google:
			detailViewDataSource.detailViewModel.open(googleSearch: detailCellViewModel.subtitle)
		case .phoneNumber:
			detailViewDataSource.detailViewModel.call(phoneNumber: detailCellViewModel.subtitle)
		case .completed:
			let cell = collectionView.cellForItem(at: indexPath) as! CompletedCell
			detailViewDataSource.detailViewModel.updateCompletionStatus(with: cell.checkBox)
		case .notes:
			notesIndexPath = indexPath
			let notesViewController = NotesViewController()
			notesViewController.notesViewModel.placeItem = detailViewDataSource.detailViewModel.placeItem
			notesViewController.notesViewModel.stateModelController = detailViewDataSource.detailViewModel.stateModelController
			notesViewController.notesViewModel.updateDetailNotesCell = update(notes:)
			navigationController?.pushViewController(notesViewController, animated: true)
		}
		
		collectionView.deselectItem(at: indexPath, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		collectionView.cellForItem(at: indexPath)?.backgroundColor = R.color.selectedCellGray()
		return true
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		collectionView.cellForItem(at: indexPath)?.isSelected = false
	}
}

// MARK: - UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		navigationItem.rightBarButtonItem = nil
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(titleDidEndEditing))
		navigationItem.rightBarButtonItem = doneButton
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		navigationItem.rightBarButtonItem = nil
		guard let newTitle = textField.text else { return }
		detailViewDataSource.detailViewModel.update(.placeTitle, with: newTitle)
	}
	
	@objc private func titleDidEndEditing() {
		detailView.navigationTextField.resignFirstResponder()
	}
}
