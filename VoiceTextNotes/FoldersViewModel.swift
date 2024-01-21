//
//  FoldersViewModel.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import Combine

class FoldersViewModel: ObservableObject {
    @Published var folders: [Folder] = []

    func addFolder(name: String) {
        let newFolder = Folder(name: name)
        folders.append(newFolder)
    }
}

