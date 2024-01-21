//
//  NoteDetailView.swift
//  VoiceTextNotes
//
//  Created by Unmesh Gundecha on 21/1/24.
//

import SwiftUI
import AVFoundation

struct AddNoteView: View {
    @Binding var folder: Folder
    @State private var noteTitle = ""
    @State private var noteText = ""
    @State private var tags = ""
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recording = false
    @State private var voiceMemoURL: URL?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            TextField("Title", text: $noteTitle)
            TextField("Note", text: $noteText)
            TextField("Tags (comma separated)", text: $tags)
            
            Button(recording ? "Stop Recording" : "Record Voice Memo") {
                recording ? stopRecording() : startRecording()
            }

            Button("Save Note") {
                let newNote = Note(title: noteTitle, voiceMemoURL: voiceMemoURL, textContent: noteText, tags: tags.components(separatedBy: ","))
                folder.notes.append(newNote)
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            }
        }
    }

    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            recording = true
            voiceMemoURL = audioFilename
        } catch {
            print("Could not start recording")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        recording = false
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

