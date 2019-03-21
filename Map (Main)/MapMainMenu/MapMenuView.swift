//
//  MapMenuView.swift
//  Tern
//
//  Created by Zach Chen on 5/7/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit

class MapMenuView: UIView {
	
	// MARK: INITIALIZERS
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: TARGETS
	var mapMenuViewController: MapMenuViewController? {
		didSet {
			backdropView.addGestureRecognizer(UITapGestureRecognizer(target: mapMenuViewController, action: #selector(MapMenuViewController.dismissMenu(_:))))
			exitButton.addTarget(mapMenuViewController, action: #selector(MapMenuViewController.exitDidTap), for: .touchUpInside)
			mapTypeChoice.addTarget(mapMenuViewController, action: #selector(MapMenuViewController.mapTypeChoice(_:)), for: .valueChanged)
			menuTableView.delegate = mapMenuViewController
		}
	}
	
	// MARK: CUSTOM BUTTONS
	
	// backdrop
	lazy var backdropView = BlackOverlay()
	
	// menu
	let menuView = MenuView()
	let exitButton = ExitButton()

	let mapTypeChoice: UISegmentedControl = {
		let items = ["Standard", "Hybrid", "Satellite"]
		let control = UISegmentedControl(items: items)
		control.selectedSegmentIndex = 0
		control.layer.borderWidth = 1
		control.layer.borderColor = UIColor.black.cgColor
		control.layer.cornerRadius = 15
		control.backgroundColor = UIColor.black
		control.tintColor = UIColor.white
		control.clipsToBounds = true
		control.translatesAutoresizingMaskIntoConstraints = false
		return control
	}()
	
	let separator = SeparatorLine()
	let menuTableView = StandardTableView()
	
	// MARK: SET UP BUTTONS
	private func configureUIModifications() {
		
		// backdrop
		backdropView.backgroundColor?.withAlphaComponent(0.5)
		
		// menu
		separator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
	}
	
	func configureView() {
		
		configureUIModifications()
		backgroundColor = .clear
		
		// backdrop View
		addSubview(backdropView)
		backdropView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		backdropView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		backdropView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		backdropView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		
		// menu View
		addSubview(menuView)
		menuView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		menuView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		menuView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		menuView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/5).isActive = true
		
		// exit Button
		addSubview(exitButton)
		if #available(iOS 11, *) {
			let safeArea = safeAreaLayoutGuide
			exitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25.5).isActive = true
			exitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 86.5).isActive = true
			exitButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
			exitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		} else {
			exitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25.5).isActive = true
			exitButton.topAnchor.constraint(equalTo: topAnchor, constant: 99.5).isActive = true
			exitButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
			exitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		}
		
		// map Type Choice
		menuView.addSubview(mapTypeChoice)
		mapTypeChoice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		mapTypeChoice.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 20).isActive = true
		mapTypeChoice.widthAnchor.constraint(equalTo: widthAnchor, constant: -30).isActive = true
		mapTypeChoice.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		// separator
		menuView.addSubview(separator)
		separator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		separator.topAnchor.constraint(equalTo: mapTypeChoice.bottomAnchor, constant: 20).isActive = true
		separator.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
		separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

		// menu Table View
		menuView.addSubview(menuTableView)
		menuTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		menuTableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20).isActive = true
		menuTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		menuTableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
	}
}

// MARK: VIEWCONTROLLER ANIMATION
extension MapMenuViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView
		let toViewController = transitionContext.viewController(forKey: .to)
		guard let toVC = toViewController else { return }
		isPresenting = !isPresenting
		
		if isPresenting == true {
			containerView.addSubview(toVC.view)
			mapMenuView.menuView.frame.origin.y += mapMenuView.menuView.frame.height
			mapMenuView.backdropView.alpha = 0
			
			UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
				self.mapMenuView.menuView.frame.origin.y -= self.mapMenuView.menuView.frame.height
				self.mapMenuView.backdropView.alpha = 1
				self.mapMenuView.exitButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
				
			}, completion: { (finished) in
				transitionContext.completeTransition(true)
			})
		} else {
			UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
				self.mapMenuView.menuView.frame.origin.y += self.mapMenuView.menuView.frame.height
				self.mapMenuView.backdropView.alpha = 0
				self.mapMenuView.exitButton.transform = .identity
				
			}, completion: { (finished) in
				transitionContext.completeTransition(true)
			})
		}
		
	}
}

