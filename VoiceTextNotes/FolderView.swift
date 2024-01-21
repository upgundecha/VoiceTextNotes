//
//  FolderView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI
import AVFoundation

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var parent: FolderView

    init(parent: FolderView) {
        self.parent = parent
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            parent.playAudio()
        }
    }
}

struct FolderView: View {
    @Binding var folder: Folder
    @State private var showingAddNote = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var noteQueue: [Note] = []
    @State private var audioPlayerDelegate: AudioPlayerDelegate?

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
            Button("Play All") {
               playAllVoiceMemos()
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(folder: $folder)
        }
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error.localizedDescription)")
        }
    }

    func playAudio() {
        configureAudioSession()
        guard !noteQueue.isEmpty else { return }
        let note = noteQueue.removeFirst()
        guard let url = note.voiceMemoURL else {
            playAudio() // Skip to the next note if this one doesn't have a voice memo
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayerDelegate = AudioPlayerDelegate(parent: self)
            audioPlayer?.delegate = audioPlayerDelegate
            audioPlayer?.play()
        } catch {
            // handle error
            print("Audio file not found.")
        }
    }

    private func playAllVoiceMemos() {
        noteQueue = folder.notes
        playAudio()
    }

    private func deleteNote(at offsets: IndexSet) {
        folder.notes.remove(atOffsets: offsets)
    }
}
