//
//  ListViewController.swift
//  mapApp Official
//
//  Created by Zach Chen on 8/16/17.
//  Copyright © 2017 Zach Chen. All rights reserved.
//

import UIKit
import MapKit

class ListViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: PROPERTIES
    let searchController = UISearchController(searchResultsController: nil)
    var editButton: UIBarButtonItem?

    // view
	var listView: ListView! { return self.view as? ListView }

    override func loadView() {
        view = ListView(frame: UIScreen.main.bounds)
        listView.configureView()
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }
    
    // MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // nav bar and empty state
        listView.headerTitle(title: (selectedCollection?.collectionTitle)!, navigationItem: self.navigationItem)
        setupNavigationItems()
        listView.setupEmptyStateView()
        
        // load the list
        checkForEmptyState()
        setupNotificationObservers()
    }
    
    func setupNavigationItems() {
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        let button = UIBarButtonItem(title: "Collections", style: .plain, target: self, action: #selector(displayCollections))
        self.navigationItem.setLeftBarButton(button, animated: true)
    }
    
    @objc func editButtonPressed() {
        listView.tableView.setEditing(!listView.tableView.isEditing, animated: true)
        self.navigationItem.rightBarButtonItem?.title = listView.tableView.isEditing ? "Done" : "Edit"
    }
    
    var didSetupSearchBar = false
    override func viewDidLayoutSubviews() {
        if !didSetupSearchBar {
            didSetupSearchBar = true
            listView.setupSearchBar(searchController: searchController, viewController: self)
        }
    }
    
    // setup notification observers
    func setupNotificationObservers() {
        
        // new place added to collection
        NotificationCenter.default.addObserver(self, selector: #selector(self.addPlaceToList(_:)), name: .placeAddedToCollection, object: nil)
        
        // place removed from collection
        NotificationCenter.default.addObserver(self, selector: #selector(self.placeRemoved(_:)), name: .placeDeletedFromCollection, object: nil)
    }

    // MARK: MANAGE THE LIST
    func checkForEmptyState() {
        ListModel.checkForEmptyState(tableView: self.listView.tableView, navigationItem: self.navigationItem, button: self.editButton!)
    }
    
    func loadList() {
        FirestoreMethods.loadCollectionItems {
    
            // refresh the table and map
            self.listView.tableView.reloadData()
            NotificationCenter.default.post(name: .mapReload, object: nil)
            
            // check for empty state
            if annotationList.count != 0 {
                
                self.listView.tableView.backgroundView?.isHidden = true
                self.listView.tableView.tableHeaderView?.isHidden = false
                
                if selectedCollection?.key != masterCollection?.key {
                    self.navigationItem.rightBarButtonItem = self.editButton
                } else {
                    self.navigationItem.rightBarButtonItem = nil
                }

            } else {
                self.listView.tableView.backgroundView?.isHidden = false
                self.listView.tableView.tableHeaderView?.isHidden = true
            }
        }
    }
    
    @objc func addPlaceToList(_ notification: NSNotification) {
            
        // refresh the table
        self.listView.tableView.reloadData()
        
        // only call these when it goes from empty state to non empty state
        if annotationList.count == 1 {
            self.listView.tableView.backgroundView?.isHidden = true
            self.listView.tableView.tableHeaderView?.isHidden = false
            self.listView.offsetTable()
            
            // add the editButton if it's not the master collection
            if selectedCollection?.key != masterCollection?.key {
                self.navigationItem.rightBarButtonItem = self.editButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }

        }
    }
    
    @objc func placeRemoved(_ notification: NSNotification) {
        
        // check blank state after deleting item
        listView.tableView.reloadData()
        
        if annotationList.count != 0 {
            return
        } else {
            self.listView.tableView.backgroundView?.isHidden = false
            self.listView.tableView.tableHeaderView?.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: DELETE ITEM
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove from ALL collections as well
            if selectedCollection?.key == masterCollection?.key {//&& collectionViewController.collections.count > 1 {
                
                // check if user wants to see this or not
                if UserDefaults.standard.value(forKey: "masterListDeleteConfirmation") == nil {
                    
                    // confirm that it will delete on all collections as well (move to Alerts class)
                    let alert = UIAlertController(title: "Delete from all Collections?", message: "Deleting a Place from 'All Places' will delete the Place from all Collections as well. Proceed? \n\n\n", preferredStyle: .alert)
                    
                    // create don't show again
                    let checkbox = BEMCheckBox()
                    checkbox.onTintColor = UIColor(red: 0.0275, green: 0.5725, blue: 0.5725, alpha: 1.0) /* #079292 */
                    checkbox.onCheckColor = UIColor(red: 0.0275, green: 0.5725, blue: 0.5725, alpha: 1.0) /* #079292 */
                    checkbox.onAnimationType = BEMAnimationType.bounce
                    checkbox.offAnimationType = BEMAnimationType.flat
                    checkbox.frame = CGRect(x: view.frame.midX - (view.frame.width / 4) - 30, y: 110, width: 20, height: 20)
                    
                    let label = UILabel()
                    label.text = "Don't ask me again"
                    label.font = UIFont(name: "Roboto-Regular", size: 12)
                    label.frame = CGRect(x: view.frame.midX - (view.frame.width / 4), y: 110, width: view.frame.width - 65, height: 20)
                    
                    // create action buttons
                    let okayAction = UIAlertAction(title: "Delete", style: .default, handler: { (delete) in
                        self.deleteItemFromCollection(indexPath: indexPath)
                        ListModel.deletePlaceFromAllCollections()
                        
                        if checkbox.on {
                            UserDefaults.standard.set(false, forKey: "masterListDeleteConfirmation")
                        }
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    // add everything to alertcontroller
                    alert.view.tintColor = UIColor(red: 0.0275, green: 0.5725, blue: 0.5725, alpha: 1.0) /* #079292 */
                    alert.view.addSubview(checkbox)
                    alert.view.addSubview(label)
                    alert.addAction(okayAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                
                } else {
                
                    // (selected collection = master collection) + (delete from all collections reminder disabled)
                    
                    // array and firestore selected collection
                    self.deleteItemFromCollection(indexPath: indexPath)
                    
                    // all collections
                    ListModel.deletePlaceFromAllCollections()
                }
                
            } else {
                
                deleteItemFromCollection(indexPath: indexPath)
            }
        }
    }
    
    func deleteItemFromCollection(indexPath: IndexPath) {
        ListModel.deleteItemFromCollection(indexPath: indexPath, searchController: searchController, tableView: listView.tableView)
    }
    
    // MARK: REORDER ITEMS
	
	// enable the reorder control
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = annotationList[sourceIndexPath.row]
        annotationList.remove(at: sourceIndexPath.row)
        annotationList.insert(movedObject, at: destinationIndexPath.row)
        
        // update firebase
        let listIndex = destinationIndexPath.row
        FirestoreMethods.reorderPlaceIndex(listIndex: listIndex)
        
    }
    
    // MARK: REFRESH TABLE VIEW EVERY TIME USER GOES BACK TO LIST VIEW
    var tableNeedsToReload = false
    override func viewWillAppear(_ animated: Bool) {
        if tableNeedsToReload {
            listView.tableView.reloadData()
            tableNeedsToReload = false
        }
    }
    
    // MARK: INSTANTIATE CollectionViewController
    @objc func displayCollections() {
        let collectionViewController = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        collectionViewController.firstHandleTitleViewDelegate = self
        collectionViewController.handleListReloadDelegate = self
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
    
    // MARK: INSTANTIATE MapListViewController
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapListViewController") as? MapListViewController {
            
            let selectedItem: AnnotationListItem
            if isFiltering() {
                selectedItem = filteredAnnotationList[indexPath.row]
            } else {
                selectedItem = annotationList[indexPath.row]
            }
            
            let coordinate = CLLocationCoordinate2DMake((selectedItem.coordinate?.latitude)!, (selectedItem.coordinate?.longitude)!)
            
            mapCoordinate = coordinate
            vc.selectedIndexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: INSTANTIATE DetailViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if isFiltering() {
                vc.note = filteredAnnotationList[indexPath.row]
                guard let key = vc.note?.key else { return }
                vc.annotationObject = annotationList.index(where: { $0.key == key })
                vc.completed = filteredAnnotationList[indexPath.row].completed!
                
            } else {
                
                vc.note = annotationList[indexPath.row]
                let key = vc.note?.key
                vc.annotationObject = annotationList.index(where: { $0.key == key })
                vc.completed = annotationList[indexPath.row].completed!
                
            }
            navigationController?.pushViewController(vc, animated: true)
            tableNeedsToReload = true
        }
    }
    
    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: MANAGE SEARCH
extension ListViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredAnnotationList = annotationList.filter({ (annotationListItem: AnnotationListItem) -> Bool in
            return (annotationListItem.annotationTitle?.lowercased().contains(searchText.lowercased()))! || (annotationListItem.annotationSubtitle?.lowercased().contains(searchText.lowercased()))!
        })
        
        listView.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return ListModel.isFiltering(searchController: searchController)
    }
    
    // only thing here that needs UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: HANDLE CHANGED COLLECTION
extension ListViewController: FirstHandleTitleView {
    @objc func changeTitleView(title: String) {
        listView.headerTitle(title: title, navigationItem: self.navigationItem)
    }
}

extension ListViewController: HandleListReload {
    func reloadTable() {
        
        loadList()
    }
}











