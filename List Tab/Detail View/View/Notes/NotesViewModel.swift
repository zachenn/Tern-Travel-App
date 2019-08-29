//
//  NotesViewModel.swift
//  Tern
//
//  Created by Zach Chen on 8/17/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import Foundation

class NotesViewModel {
	
	// MARK: - Properties
	var placeItem: PlaceItem?
	var stateModelController: StateModelController?
	
	// MARK: - Closures
	var updateDetailNotesCell: (_ notes: String) -> () = {_ in}

	// MARK: - Methods
	func update(notes: String) {
		guard let place = placeItem else { return }
		stateModelController?.update(.notes, with: notes, for: place, from: self)
		updateDetailNotesCell(notes)
	}
}
