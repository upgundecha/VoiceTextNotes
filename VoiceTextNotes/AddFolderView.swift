//
//  AddFolderView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI

struct AddFolderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var folderName = ""
    var viewModel: FoldersViewModel

    var body: some View {
        NavigationView {
            Form {
                TextField("Folder Name", text: $folderName)
                Button("Add Folder") {
                    viewModel.addFolder(name: folderName)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .navigationTitle("New Folder")
        }
    }
}
