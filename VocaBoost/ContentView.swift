//
//  ContentView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import SwiftUI
import Supabase
import AVFoundation

struct ContentView: View {
    @State private var vocabulary: [Instrument] = []
    @State private var isLoading: Bool = false
    @State private var dataInput: String = ""
    @State private var currentWord: WordModel = .init(.null)
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            VStack {
                TextField("abc", text: $dataInput).padding()
                
                List(vocabulary) { word in
                    HStack {
                        Button(action: {
                            
                        }) {
                            Text(word.name + " " + (word.phonetic ?? "")).foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "mic.fill")
                            .font(.none)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                speak(word.name)
                            }
                    }
                }
                .listRowSeparator(.hidden)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
                .task {
                    await fetchVocabulary()
                }
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        Button("reload") {
                            isLoading = true
                            defer { isLoading = false }
                            
                            Task {
                                await fetchVocabulary()
                            }
                        }
                        .buttonStyle(.bordered)
                        HStack {
                            Button("insert") {
                                let random = Int.random(in: 1...100)
                                let ins: Instrument = .init(id: random, name: currentWord.word, type: currentWord.type, phonetic: currentWord.phonetic ?? "", meaning: currentWord.meaning)
                                Task {
                                    await insertInstrument(ins)
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("update") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                Task {
                                    await updateData()
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("delete all") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                Task {
                                    await deleteAllRow()
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("inquiry") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                Task {
                                    await inquiryWordInfor(dataInput)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
    }
    
    private func insertInstrument(_ instrument: Instrument) async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            try await supabase.from("vocabulary").insert(instrument).select().execute()
            await fetchVocabulary()
            
            dataInput = ""
        } catch {
            dump(error)
        }
    }
    
    private func fetchVocabulary() async {
        do {
            vocabulary = try await supabase.from("vocabulary").select().execute().value
        } catch {
            dump(error)
        }
    }
    
    private func removeInstrument() async {
        do {
            try await supabase
              .from("vocabulary")
              .delete()
              .eq("id", value: 7)
              .execute()
            await fetchVocabulary()
        } catch {
            dump(error)
        }
    }
    
    private func updateData() async {
        do {
            try await supabase
              .from("vocabulary")
              .update(["name": "concac"])
              .eq("id", value: 7)
              .execute()
        } catch {
            dump(error)
        }
    }
    
    private func deleteAllRow() async {
        do {
            try await supabase
              .from("vocabulary")
              .delete()
              .gte("id", value: 0)
              .execute()
        } catch {
            dump(error)
        }
    }
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // English voice
        synthesizer.speak(utterance)
    }
    
    private func inquiryWordInfor(_ word: String) async {
        do {
            let url = "\(apiDictionaryUrl)\(word.lowercased())"
            let data = try await NetworkManager.shared.request(url: url)
            let decoder = JSONDecoder()
            let words = try decoder.decode([WordModel].self, from: data)
            self.currentWord = words.first ?? .init(.null)
        } catch {
            dump(error)
        }
    }
}

#Preview {
    ContentView()
}
