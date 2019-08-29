//
//  ListTabViewController.swift
//  Tern
//
//  Created by Zach Chen on 6/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class ListTabViewController: UIViewController {
	
	// MARK: - Properties
	var listTabView: ListTabView! { return self.view as? ListTabView }
	var listTabDataSource = ListTabDataSource()
	
	private var dataState: DataState = .empty {
		didSet {
			switch dataState {
			case .empty:
				self.listTabView.listTableView.backgroundView?.isHidden = false
				self.listTabView.listTableView.tableHeaderView?.isHidden = true
				self.navigationItem.rightBarButtonItem = nil
				self.listTabView.listTableView.reloadData()
			case .dataLoaded:
				self.listTabView.listTableView.backgroundView?.isHidden = true
				self.listTabView.listTableView.tableHeaderView?.isHidden = false
				// FIXME: edit when i add master list
				//				self.navigationItem.rightBarButtonItem = selectedCollection?.key != masterCollection?.key ? self.editButton : nil
//				if annotationList.count == 1 { self.listView.offsetTable() }
				self.navigationItem.rightBarButtonItem = listTabView.editButton
				self.listTabView.listTableView.reloadData()
			}
		}
	}
	
	private var selectedRowIndexPath: IndexPath?
	
	// MARK: - Lifecycle Methods
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		bindElementsToViewModel()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = ListTabView(frame: UIScreen.main.bounds)
		listTabView.listTableView.delegate = self
		listTabView.listTableView.dataSource = listTabDataSource
		listTabView.listTabViewController = self
	}
	
	override func viewDidLoad() {
		setupNavigationItems()
	}
	
	// MARK: - Setup Methods
	private func setupNavigationItems() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.leftBarButtonItem = listTabView.collectionButton
		listTabDataSource.listTabViewModel.updateDataState()
	}
	
	private func bindElementsToViewModel() {
		listTabDataSource.listTabViewModel.updateDataStateClosure = update(_ :)
		listTabDataSource.listTabViewModel.reloadTableViewClosure = { [weak self] in
			DispatchQueue.main.async {
				self?.listTabView.listTableView.reloadData()
				self?.listTabDataSource.listTabViewModel.updateDataState()
			}
		}
		
		listTabDataSource.listTabViewModel.reloadTableViewRow = reloadTableViewRow(with:)
		listTabDataSource.listTabViewModel.insertTableViewRow = insertTableViewRow(in:)
		listTabDataSource.listTabViewModel.insertTableViewSection = insertTableViewSection(section:)
		listTabDataSource.listTabViewModel.setNavigationTitleClosure = setNavigationTitle
		listTabDataSource.listTabViewModel.removeSectionClosure = remove(section:)
	}
	
	private func update(_ dataState: DataState) {
		self.dataState = dataState
	}
	
	private func setNavigationTitle(title: String) {
		navigationItem.title = title
	}
	
	private func reloadTableViewRow(with key: String) {
		guard let indexPath = selectedRowIndexPath else { return }
		listTabView.listTableView.reloadRows(at: [indexPath], with: .none)
	}
	
	private func insertTableViewSection(section: Int) {
		listTabView.listTableView.insertSections(IndexSet(integer: section), with: .none)
	}
	
	private func insertTableViewRow(in section: Int) {
		let row = listTabDataSource.listTabViewModel.numberOfRowsIn(section: section) - 1
		listTabView.listTableView.insertRows(at: [IndexPath(row: row, section: section)], with: .none)
	}
	
	private func remove(section: Int) {
		listTabView.listTableView.deleteSections([section], with: .fade)
	}
	
	// MARK: - Navigation Button Actions
	@objc func editButtonDidPress() {
		listTabView.listTableView.setEditing(!listTabView.listTableView.isEditing, animated: true)
		navigationItem.rightBarButtonItem?.title = listTabView.listTableView.isEditing ? R.string.localizable.done() : R.string.localizable.edit()
		if listTabDataSource.listTabViewModel.stateModelController?.selectedCollection?.listOrderNeedsUpdate == true {
			listTabDataSource.listTabViewModel.stateModelController?.updateListOrder()
			listTabDataSource.listTabViewModel.stateModelController?.selectedCollection?.listOrderNeedsUpdate = false
		}
	}
	
	@objc func collectionsDidPress() {
		let collectionsViewController = CollectionsViewController()
		collectionsViewController.collectionsViewDataSource.collectionsViewModel.stateModelController = listTabDataSource.listTabViewModel.stateModelController
		listTabDataSource.listTabViewModel.stateModelController?.collectionsViewModel = collectionsViewController.collectionsViewDataSource.collectionsViewModel
		navigationController?.pushViewController(collectionsViewController, animated: true)
	}
}

// MARK: - TableViewDelegate
extension ListTabViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailViewController = DetailViewController()
		
		detailViewController.detailViewDataSource.detailViewModel.placeItem = listTabDataSource.listTabViewModel.place(at: indexPath)
		detailViewController.detailViewDataSource.detailViewModel.stateModelController = listTabDataSource.listTabViewModel.stateModelController
		
		navigationController?.pushViewController(detailViewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: true)
		
		selectedRowIndexPath = indexPath
	}
	
	func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		
		let sourceSection = sourceIndexPath.section
		let destinationSection = proposedDestinationIndexPath.section
		
		if destinationSection < sourceSection {
			return IndexPath(row: 0, section: sourceSection)
		} else if destinationSection > sourceSection {
			let row = tableView.numberOfRows(inSection: sourceSection) - 1
			return IndexPath(row: row, section: sourceSection)
		}
		
		return proposedDestinationIndexPath
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.font = UIFont(name: R.font.robotoBold.fontName, size: 16)
	}
}
