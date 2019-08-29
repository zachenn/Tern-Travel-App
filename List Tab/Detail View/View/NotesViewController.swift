//
//  NotesViewController.swift
//  Tern
//
//  Created by Zach Chen on 8/16/19.
//  Copyright © 2019 Zach Chen. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
	
	// MARK: - Properties
	private var notesView: NotesView { return self.view as! NotesView }
	var notesViewModel = NotesViewModel()
	private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNotes))
	
	// MARK: - Lifecycle Methods
	override func loadView() {
		view = NotesView(frame: UIScreen.main.bounds)
		notesView.textView.delegate = self
		notesView.textView.text = notesViewModel.placeItem?.notes
	}
	
	override func viewDidLoad() {
		notesView.textView.becomeFirstResponder()
	}
}

// MARK: - UITextViewDelegate
extension NotesViewController: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		navigationItem.rightBarButtonItem = doneButton
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		guard let newNotes = textView.text else { return }
		let trimmedNewNotes = newNotes.trimmingCharacters(in: .whitespacesAndNewlines)
		if trimmedNewNotes != "" {
			notesViewModel.update(notes: newNotes)
		}
	}
	
	@objc private func saveNotes() {
		notesView.textView.resignFirstResponder()
		navigationItem.rightBarButtonItem = nil
	}
}
