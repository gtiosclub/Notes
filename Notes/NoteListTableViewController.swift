//
//  NoteListTableViewController.swift
//  Notes
//
//  Created by Kevin Randrup on 10/16/16.
//  Copyright © 2016 Kevin Randrup. All rights reserved.
//

import UIKit

class NoteListTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let noteDatabase = NoteDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.title = "Notes"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // Making this method @objc lets you use #selector().
    //private dynaimc func newNote() { // You can also use "dynamic"
    @objc private dynamic func newNote() {
        self.performSegue(withIdentifier: "Note Segue", sender: nil)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteDatabase.countNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The cell has a style of Right Detail, which means we have a textLabel and detailTextLabel.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath)
        let note = self.noteDatabase.note(atIndex: indexPath.row)
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.lastUpdated.description
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Access the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let noteVC = segue.destination as? NoteViewController {
            // Show existing note
            if let selectedCell = sender as? UITableViewCell,
                let selectedIndex = tableView.indexPath(for: selectedCell) {
                noteVC.note = self.noteDatabase.note(atIndex: selectedIndex.row)
            }
            
            // When the note is updated then we're going to call the reload method just below
            noteVC.updateNotification = self.update
            // When a new note is created and needs to be saved call the saveNew method just below
            noteVC.saveNotification = self.saveNew
        }
    }
    
    private func update(note: Note) {
        noteDatabase.update(note: note)
        tableView.reloadData()
    }
    
    private func saveNew(note: Note) {
        noteDatabase.saveNew(note: note)
        tableView.reloadData()
    }
}

