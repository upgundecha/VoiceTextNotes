//
//  HomeView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @State private var showingAddFolder = false
    @ObservedObject var viewModel = FoldersViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.folders.indices, id: \.self) { index in
                    NavigationLink(destination: FolderView(folder: $viewModel.folders[index])) {
                        Text(viewModel.folders[index].name)
                    }
                }
            }
            .navigationTitle("Folders")
            .toolbar {
                Button(action: { showingAddFolder = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddFolder) {
                AddFolderView(viewModel: viewModel)
            }
        }
    }
}

