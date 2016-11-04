//
//  Note.swift
//  Notes
//
//  Created by Kevin Randrup on 10/16/16.
//  Copyright © 2016 Kevin Randrup. All rights reserved.
//

import Foundation

class Note {
    var title: String
    var body: String
    var lastUpdated: Date
    
    init(title: String, body: String, lastUpdated: Date) {
        self.title = title
        self.body = body
        self.lastUpdated = lastUpdated
    }
}
