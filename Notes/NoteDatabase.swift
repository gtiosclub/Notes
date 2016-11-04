//
//  NoteDatabase.swift
//  Notes
//
//  Created by Kevin Randrup on 10/18/16.
//  Copyright © 2016 Kevin Randrup. All rights reserved.
//

import Foundation

/// Stores notes with the most recently updated being dispayed first
class NoteDatabase {
    private var notes: [Note] = []
    
    init() {
        notes = Persistence.load()
    }
    
    /// - Returns: The number of notes in the database
    var countNotes: Int {
        return notes.count
    }
    
    /// - Returns: The note at the given index
    func note(atIndex index: Int) -> Note {
        return notes[index]
    }
    
    func update(note: Note) {
        synchronize()
    }
    
    /// Saves the note to the database, ordered by most recently updated
    func saveNew(note: Note) {
        notes.append(note)
        synchronize()
    }
    
    private func synchronize() {
        notes.sort(by: { $0.lastUpdated > $1.lastUpdated })
        Persistence.save(notes: notes)
    }
    
    private struct Persistence {
        private static let key = "Notes.NoteDatabase.Key"

        static func save(notes: [Note]) {
            var data: [[String:Any]] = []
            for note in notes {
                let noteData: [String:Any] = ["title" : note.title, "body" : note.body, "lastUpdated" : note.lastUpdated]
                data.append(noteData)
            }
            /*
            //Advanced version using map
            let data = notes.map { (note) -> [String : Any] in
                return ["title" : note.title, "body" : note.body, "lastUpdated" : note.lastUpdated]
            }
            */
            UserDefaults.standard.set(data, forKey: Persistence.key)
        }
        
        static func load() -> [Note] {
            let savedData = UserDefaults.standard.array(forKey: Persistence.key) as? [[String:AnyObject]] ?? []
            var array: [Note] = []
            for noteData in savedData {
                if let title = noteData["title"] as? String,
                    let body = noteData["body"] as? String,
                    let lastUpdated = noteData["lastUpdated"] as? Date {
                    array.append(Note(title: title, body: body, lastUpdated: lastUpdated))
                }
            }
            return array

            /*
            //Advanced version using map
            return savedData.flatMap { (data) -> Note? in
                guard let title = data["title"] as? String,
                    let body = data["body"] as? String,
                    let lastUpdated = data["lastUpdated"] as? Date
                    else { return nil }
                return Note(title: title, body: body, lastUpdated: lastUpdated)
            }
            */
        }
    }
}
