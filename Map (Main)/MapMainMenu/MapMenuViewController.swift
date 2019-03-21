//
//  MapMenuViewController.swift
//  Tern
//
//  Created by Zach Chen on 10/27/17.
//  Copyright © 2017 Zach Chen. All rights reserved.
//

import UIKit
import MessageUI

class MapMenuViewController: UIViewController, UITableViewDelegate, MFMailComposeViewControllerDelegate {

	// MARK: PROPERTIES
	var isPresenting = false
	
	// MARK: SET UP VIEW
	var mapMenuView: MapMenuView! { return self.view as? MapMenuView }
	let mapMenuDataSource = MapMenuDataSource()
	
	override func loadView() {
		view = MapMenuView(frame: UIScreen.main.bounds)
		mapMenuView.configureView()
		mapMenuView.mapMenuViewController = self
		mapMenuView.menuTableView.dataSource = mapMenuDataSource
	}
	
	// MARK: VIEWDIDLOAD
	override func viewDidLoad() {
		super.viewDidLoad()

	}
	
	// MARK: BUTTON ACTIONS
	
	// mapTypeChoice
	@objc func mapTypeChoice(_ sender: UISegmentedControl) {
		MapMenuModel.mapTypeChoice(sender: sender)
	}
	
	// dismiss View Controller by tapping on black area
	@objc func dismissMenu(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
		NotificationCenter.default.post(name: .reviveMapTypeButton, object: nil)
	}
	
	// dismiss View Controller by tapping on exit
	@objc func exitDidTap() {
		dismiss(animated: true, completion: nil)
		NotificationCenter.default.post(name: .reviveMapTypeButton, object: nil)
	}
	
	// MARK: INITIALIZE TRANSITION
	init() {
		super.init(nibName: nil, bundle: nil)

		// transition
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: TABLEVIEW ACTIONS
	
	// cell selection
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath)
		
		switch (cell?.textLabel?.text) {
		case ("Settings"):
			
			// settings
			let settingsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
			let settingsTableViewControllerNav = UINavigationController(rootViewController: settingsTableViewController)
			self.present(settingsTableViewControllerNav, animated: true, completion: nil)
			
		case "Give Us Feedback":
			
			// feedback
			let feedbackViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
			let feedbackViewControllerNav = UINavigationController(rootViewController: feedbackViewController)
			self.present(feedbackViewControllerNav, animated: true, completion: nil)
			
		case "Contact Us":

			// contact us
			let mailViewController = MFMailComposeViewController()
			mailViewController.mailComposeDelegate = self
			mailViewController.setToRecipients(["ternappofficial@gmail.com"])
			mailViewController.setSubject("Subject")
			mailViewController.setMessageBody("Message", isHTML: false)
			
			present(mailViewController, animated: true, completion: nil)
			
		default: break;
			
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: EMAIL DELEGATE
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}














