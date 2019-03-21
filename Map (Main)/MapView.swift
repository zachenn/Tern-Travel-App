//
//  MapView.swift
//  Tern
//
//  Created by Zach Chen on 5/6/18.
//  Copyright © 2018 Zach Chen. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
	
	// MARK: INITIALIZERS
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: TARGETS
	var mapViewController: MapViewController? {
		didSet {
			
			// targets
			plusButton.addTarget(mapViewController, action: #selector(MapViewController.openMapMenu), for: .touchUpInside)
			refreshLocationButton.addTarget(mapViewController, action: #selector(MapViewController.handleRefreshLocation), for: .touchUpInside)
			showAllAnnotationsButton.addTarget(mapViewController, action: #selector(MapViewController.handleShowAllAnnotations), for: .touchUpInside)
			
			// delegates
			mapView.delegate = mapViewController
		}
	}
	
	// MARK: CREATE UI OBJECTS
	
	// map view
	let mapView = MKMapView()
	
	// map actions
	let blurView = MapActionsBlurView()
	let plusButton = FloatingActionButton()
	let objectSeparator = SeparatorLine()
	let refreshLocationButton = SmallImageButton()
	let objectSeparator2 = SeparatorLine()
	let showAllAnnotationsButton = SmallImageButton()
	let showAllAnnotationsButtonGlow = SmallImageButton()
	
	// reveal show all annotations button
	let showAllAnnotationsButtonReveal = DarkBlurView()
	let showAllAnnotationsButtonRevealPointer = DarkBlurView()
	let showAllAnnotationsButtonRevealText = SmallLabel()
	
	// MARK: CUSTOM UI CONSTRAINTS
	func configureUIModifications() {
		
		// map
		mapView.translatesAutoresizingMaskIntoConstraints = false
		
		// map actions
		plusButton.styleFloatingActionButton()
		refreshLocationButton.refreshLocationButton()
		
		showAllAnnotationsButton.setImage(UIImage(named: "nodes #079292"), for: .normal)
		showAllAnnotationsButton.styleSmallImageButton()
		showAllAnnotationsButtonGlow.setImage(UIImage(named: "nodes #079292"), for: .normal)
		showAllAnnotationsButtonGlow.styleSmallImageButton()
		showAllAnnotationsButtonGlow.smallImageButtonGlow()
		
		objectSeparator.blackSeparator()
		objectSeparator2.blackSeparator()
		
		// show all annotations button reveal
		showAllAnnotationsButtonReveal.styleShowAllAnnotationsButtonReveal()
		showAllAnnotationsButtonRevealPointer.styleShowAllAnnotationsButtonRevealPointer()
		showAllAnnotationsButtonRevealText.text = "Now that you have a few Places saved, tap me and I can show you the world!"
		showAllAnnotationsButtonRevealText.font.withSize(14)
		showAllAnnotationsButtonRevealText.textAlignment = .center
		
	}
	
	func configureButtonView() {
	
		configureUIModifications()
		
		// map View
		addSubview(mapView)
		mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		mapView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		
		// blur view
		mapView.addSubview(blurView)
		if #available(iOS 11, *) {
			let safeArea = safeAreaLayoutGuide
			blurView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15).isActive = true
			blurView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
			blurView.widthAnchor.constraint(equalToConstant: 46).isActive = true
			blurView.heightAnchor.constraint(equalToConstant: 134).isActive = true
		} else {
			blurView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
			blurView.topAnchor.constraint(equalTo: topAnchor, constant: 90).isActive = true
			blurView.widthAnchor.constraint(equalToConstant: 46).isActive = true
			blurView.heightAnchor.constraint(equalToConstant: 134).isActive = true
		}

		// plus Button
		blurView.addSubview(plusButton)
		plusButton.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 8.5).isActive = true
		plusButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 8.5).isActive = true
		plusButton.widthAnchor.constraint(equalToConstant: 29).isActive = true
		plusButton.heightAnchor.constraint(equalToConstant: 29).isActive = true

		// object Separator
		blurView.addSubview(objectSeparator)
		objectSeparator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
		objectSeparator.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 7.5).isActive = true
		objectSeparator.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -6).isActive = true
		objectSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

		// refresh Location Button
		blurView.addSubview(refreshLocationButton)
		refreshLocationButton.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
		refreshLocationButton.topAnchor.constraint(equalTo: objectSeparator.bottomAnchor).isActive = true
		refreshLocationButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -2).isActive = true
		refreshLocationButton.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 1/3).isActive = true

		// object Separator 2
		blurView.addSubview(objectSeparator2)
		objectSeparator2.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
		objectSeparator2.topAnchor.constraint(equalTo: refreshLocationButton.bottomAnchor).isActive = true
		objectSeparator2.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -6).isActive = true
		objectSeparator2.heightAnchor.constraint(equalToConstant: 1).isActive = true

		// show All Annotations Button
		blurView.addSubview(showAllAnnotationsButton)
		showAllAnnotationsButton.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
		showAllAnnotationsButton.topAnchor.constraint(equalTo: objectSeparator2.bottomAnchor).isActive = true
		showAllAnnotationsButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -2).isActive = true
		showAllAnnotationsButton.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 1/3) .isActive = true

		// show All Annotations Button Glow
		blurView.addSubview(showAllAnnotationsButtonGlow)
		showAllAnnotationsButtonGlow.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
		showAllAnnotationsButtonGlow.topAnchor.constraint(equalTo: objectSeparator2.bottomAnchor).isActive = true
		showAllAnnotationsButtonGlow.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -2).isActive = true
		showAllAnnotationsButtonGlow.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 1/3).isActive = true
	}
	
	func setupShowAllAnnotationsButtonReveal() {
		
		// pointer
		mapView.addSubview(showAllAnnotationsButtonRevealPointer)
		showAllAnnotationsButtonRevealPointer.rightAnchor.constraint(equalTo: blurView.leftAnchor, constant: -5).isActive = true
		showAllAnnotationsButtonRevealPointer.centerYAnchor.constraint(equalTo: showAllAnnotationsButton.centerYAnchor).isActive = true
		showAllAnnotationsButtonRevealPointer.widthAnchor.constraint(equalToConstant: 20).isActive = true
		showAllAnnotationsButtonRevealPointer.heightAnchor.constraint(equalToConstant: 20).isActive = true
		showAllAnnotationsButtonRevealPointer.alpha = 0
		
		// text box
		mapView.addSubview(showAllAnnotationsButtonReveal)
		showAllAnnotationsButtonReveal.rightAnchor.constraint(equalTo: showAllAnnotationsButtonRevealPointer.leftAnchor, constant: 15).isActive = true
		showAllAnnotationsButtonReveal.centerYAnchor.constraint(equalTo: showAllAnnotationsButton.centerYAnchor).isActive = true
		showAllAnnotationsButtonReveal.widthAnchor.constraint(equalToConstant: 200).isActive = true
		showAllAnnotationsButtonReveal.heightAnchor.constraint(equalToConstant: 100).isActive = true
		showAllAnnotationsButtonReveal.alpha = 0
		
		// text
		showAllAnnotationsButtonReveal.addSubview(showAllAnnotationsButtonRevealText)
		showAllAnnotationsButtonRevealText.centerXAnchor.constraint(equalTo: showAllAnnotationsButtonReveal.centerXAnchor).isActive = true
		showAllAnnotationsButtonRevealText.centerYAnchor.constraint(equalTo: showAllAnnotationsButtonReveal.centerYAnchor).isActive = true
		showAllAnnotationsButtonRevealText.widthAnchor.constraint(equalTo: showAllAnnotationsButtonReveal.widthAnchor, constant: -10).isActive = true

	}
	
	// MARK: VIEW ACTIONS/TRANSITIONS
	func setupLocationSearchTable(locationSearchTable: LocationSearchTable, resultSearchController: UISearchController, mapView: MKMapView, delegate: MapViewController) {
		
		// set up the search results table
		resultSearchController.searchResultsUpdater = locationSearchTable
		
		// set up the search bar
		let searchBar = resultSearchController.searchBar
		searchBar.sizeToFit()
		searchBar.placeholder = "Add a place or address"
		searchBar.returnKeyType = .search
		searchBar.delegate = delegate
		delegate.navigationItem.titleView = searchBar
		
		resultSearchController.hidesNavigationBarDuringPresentation = false
		resultSearchController.dimsBackgroundDuringPresentation = true
		delegate.definesPresentationContext = true
		
		// pass along a handle of the mapView from the main View Controller onto the locationSearchTable (give locationSearchTable access to MapVC's mapView)
		locationSearchTable.mapView = mapView
		
		// wire up the protocol to drop pin and create callout
		locationSearchTable.handleMapSearchDelegate = delegate
		
	}
	
	func revealShowAllAnnotationsButton() {
		if UserDefaults.standard.value(forKey: "showAllAnnotationsButtonReveal") == nil && allMapAnnotations.count == 3 {
			
			// add showAllAnnotationsButtonReveal callout UI
			setupShowAllAnnotationsButtonReveal()
			showAllAnnotationsButtonGlow.layer.add(Animations.pulseAnimation(), forKey: "animateOpacity")
			
			// animate callout
			Animations.onboardingCallout(reveal: true, revealButton: showAllAnnotationsButtonReveal, revealPointer: showAllAnnotationsButtonRevealPointer)
			
			UserDefaults.standard.set(true, forKey: "showAllAnnotationsButtonReveal")
		}
	}
	
	func revivePlusButton() {
		Animations.revivePlusButton(button: plusButton)
	}
	
	func hideOnboardingCallout(view: UIView) {
		self.showAllAnnotationsButtonGlow.layer.removeAnimation(forKey: "animateOpacity")
		if showAllAnnotationsButtonReveal.isDescendant(of: view) {
			Animations.onboardingCallout(reveal: false, revealButton: showAllAnnotationsButtonReveal, revealPointer: showAllAnnotationsButtonRevealPointer)
		}
	}
}


























