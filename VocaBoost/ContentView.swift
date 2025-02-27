//
//  ContentView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import SwiftUI
import Supabase

struct ContentView: View {
    @State var instruments: [Instrument] = []

    var body: some View {
        List(instruments) { instrument in
            Text(instrument.name)
        }
        .overlay {
            if instruments.isEmpty {
                ProgressView()
            }
        }
        .task {
            do {
                instruments = try await supabase.from("profiles").select().execute().value
            } catch {
                dump(error)
            }
        }
        
        Button("insert") {
            let ins: Instrument = .init(id: Int.random(in: 1...100), name: "Thupro123")
            Task {
                await insertInstrument(ins)
            }
        }
        
    }
    
    private func insertInstrument(_ instrument: Instrument) async {
        do {
            let response = try await supabase.database.from("instruments").insert(instrument).select().execute()
            print(response)
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}
