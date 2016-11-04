//
//  NoteViewController.swift
//  Notes
//
//  Created by Kevin Randrup on 10/17/16.
//  Copyright © 2016 Kevin Randrup. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var note: Note?
    
    /// Called when the user saves a note
    var updateNotification: ((Note) -> Void)?
    /// Called when a new Note object is created
    var saveNotification: ((Note) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configureUI() {
        if let note = self.note {
            self.title = note.title
            self.titleTextField.text = note.title
            self.bodyTextView.text = note.body
        } else {
            self.title = "New Note"
            self.titleTextField.text = "New Note"
            self.bodyTextView.text = nil
        }
    }
    
    @objc private func save() {
        let newTitle = self.titleTextField.text ?? "New Note"
        let newBody = self.bodyTextView.text ?? ""
        if let note = self.note {
            note.title = newTitle
            note.body = newBody
            note.lastUpdated = Date()
            self.updateNotification?(note)
        } else {
            let newNote = Note(title: newTitle, body: newBody, lastUpdated: Date())
            self.saveNotification?(newNote)
        }
        
        // Go back to the list of notes
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
