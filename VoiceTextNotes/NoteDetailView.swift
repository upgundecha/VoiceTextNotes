//
//  NoteDetailView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI
import AVFoundation

struct NoteDetailView: View {
    let note: Note
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        List {
            Section(header: Text("Details").font(.headline)) {
                HStack {
                    Text("Title:")
                        .bold()
                    Spacer()
                    Text(note.title)
                }

                if let voiceMemoURL = note.voiceMemoURL {
                    HStack {
                        Text("Voice Memo:")
                            .bold()
                        Spacer()
                        Button("Play") {
                            playRecording(url: voiceMemoURL)
                        }
                    }
                }

                if !note.textContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    HStack {
                        Text(note.textContent)
                            .lineLimit(nil)
                            .padding(.vertical, 2) // Add vertical padding for the highlight effect
                            .padding(.horizontal, 5) // Add horizontal padding for the highlight effect
                            .background(Color.yellow.opacity(0.5)) // Semi-transparent yellow background
                            .cornerRadius(3) // Slightly rounded corners to mimic a highlighter's stroke
                    }
                }
                
                let nonEmptyTags = note.tags.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

                if !nonEmptyTags.isEmpty {
                    HStack {
                        Text("Tags:")
                            .bold()
                        Spacer()
                        ForEach(nonEmptyTags, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .navigationTitle("Note Details")
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error.localizedDescription)")
        }
    }

    private func playRecording(url: URL) {
        configureAudioSession()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("Playback failed")
        }
    }
}
