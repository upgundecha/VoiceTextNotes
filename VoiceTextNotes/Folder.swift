//
//  Folder.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import Foundation

struct Folder: Identifiable {
    var id = UUID()
    var name: String
    var notes: [Note]

    init(name: String, notes: [Note] = []) {
        self.name = name
        self.notes = notes
    }
}

struct Note: Identifiable {
    var id = UUID()
    var title: String
    var voiceMemoURL: URL?
    var textContent: String
    var tags: [String]
}
