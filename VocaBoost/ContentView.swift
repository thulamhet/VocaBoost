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
    @State private var instruments: [Instrument] = []
    @State private var isLoading: Bool = false
    @State private var dataInput: String = ""
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            VStack {
                TextField("abc", text: $dataInput).padding()
                
                List(instruments) { instrument in
                    HStack {
                        Text(instrument.name)
                        
                        Spacer()
                        
                        Image(systemName: "mic.fill")
                            .font(.none)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                speak(instrument.name)
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
                    await fetchInstruments()
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Button("insert") {
                            let random = Int.random(in: 1...100)
                            let ins: Instrument = .init(id: random, name: dataInput)
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
    
    private func insertInstrument(_ instrument: Instrument) async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            try await supabase.from("instruments").insert(instrument).select().execute()
            await fetchInstruments()
            
            dataInput = ""
        } catch {
            dump(error)
        }
    }
    
    private func fetchInstruments() async {
        do {
            instruments = try await supabase.from("instruments").select().execute().value
        } catch {
            dump(error)
        }
    }
    
    private func removeInstrument() async {
        do {
            try await supabase
              .from("instruments")
              .delete()
              .eq("id", value: 7)
              .execute()
            await fetchInstruments()
        } catch {
            dump(error)
        }
    }
    
    private func updateData() async {
        do {
            try await supabase
              .from("instruments")
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
              .from("instruments")
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
            let jsonString = String(data: data, encoding: .utf8) ?? "Invalid Data"
            print(jsonString)
        } catch {
            dump(error)
        }
    }
}

#Preview {
    ContentView()
}
