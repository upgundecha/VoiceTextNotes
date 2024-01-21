//
//  FolderView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI

struct FolderView: View {
    @Binding var folder: Folder
    @State private var showingAddNote = false

    var body: some View {
        List {
            ForEach(folder.notes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    Text(note.title)
                }
            }
            .onDelete(perform: deleteNote)
        }
        .navigationTitle(folder.name)
        .toolbar {
            Button("Add Note") {
                showingAddNote = true
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(folder: $folder)
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        folder.notes.remove(atOffsets: offsets)
    }
}
