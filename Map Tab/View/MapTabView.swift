//
//  MapTabView.swift
//  
//
//  Created by Zach Chen on 6/17/19.
//

import UIKit
import MapKit

class MapTabView: UIView {
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Targets
	var mapTabViewController: MapTabViewController? {
		didSet {
			refreshLocationButton.addTarget(mapTabViewController, action: #selector(mapTabViewController?.refreshLocationDidPress), for: .touchUpInside)
		}
	}
	
	// MARK: - Create UI Objects
	let mapView = MKMapView()
	
	let blurView = UIView()
	let plusButton = FloatingActionButton()
	let objectSeparator = UIView()
	let refreshLocationButton = UIButton()
	let objectSeparator2 = UIView()
	let showAllAnnotationsButton = UIButton()
	let showAllAnnotationsButtonGlow = UIButton()
	
	// MARK: - Configure View
	private func configureUIModifications() {
		
		// map view
		mapView.translatesAutoresizingMaskIntoConstraints = false
		
		// map actions
		blurView.mapActionsBlurView()
		objectSeparator.makeSeparatorLine(color: .black)
		refreshLocationButton.imageButton(image: R.image.location()!)
		objectSeparator2.makeSeparatorLine(color: .black)
		showAllAnnotationsButton.imageButton(image: R.image.nodes()!)
		showAllAnnotationsButtonGlow.imageButtongGlow(image: R.image.nodes()!)
	}
	
	private func configureView() {
		
		configureUIModifications()
		let safeArea = safeAreaLayoutGuide
		
		// map view
		addSubview(mapView)
		mapView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		mapView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		mapView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		
		// blur view
		mapView.addSubview(blurView)
		if #available(iOS 11, *) {
			blurView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
			blurView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15).isActive = true
			blurView.widthAnchor.constraint(equalToConstant: 46).isActive = true
			blurView.heightAnchor.constraint(equalToConstant: 134).isActive = true
		} else {
			blurView.topAnchor.constraint(equalTo: topAnchor, constant: 90).isActive = true
			blurView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
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
	
}
