//
//  HomeView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import SwiftUI
import Supabase
import AVFoundation
import GoogleSignIn

struct HomeView: View {
    
    @State private var vocabulary: [Vocab] = []
    @State private var isLoading: Bool = false
    @State private var dataInput: String = ""
    @State private var currentWord: WordModel = .init(.null)
    @State private var selectedWord: Vocab?
    @State private var user: User?
    @State private var avatarImage: UIImage?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if let image = avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(100)
                    }
                    VStack {
                        Text(user?.fullName ?? "").bold()
                        Text(user?.email ?? "").bold()
                    }
                }.padding(15)
                
                Spacer()
                
                TextField("input your fucking word", text: $dataInput).padding()
                
                List(vocabulary) { word in
                    HStack {
                        Button(action: {
                            selectedWord = word
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
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
                .task {
                    await fetchVocabulary()
                }
                .sheet(item: $selectedWord, content: { item in
                    DetailWordView(word: selectedWord).presentationDetents([.medium])
                })
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        HStack {
                            Button("reload") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                getUserInfor()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("google signin") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                Task {
                                    do {
                                        try await googleSignIn()
                                    } catch {
                                        dump(error)
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                        HStack {
                            Button("insert") {
                                let random = Int.random(in: 1...100)
                                let ins: Vocab = .init(id: random, name: currentWord.word, type: currentWord.type, phonetic: currentWord.phonetic ?? "", meaning: currentWord.meaning)
                                Task {
                                    await insertVocab(ins)
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
                            
                            Button("inquiry") {
                                isLoading = true
                                defer { isLoading = false }
                                
                                onAppear()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }.task {
            refreshToken()
        }
    }
    
    private func loadImage(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImage = loadedImage
                }
            }
        }
        task.resume()
    }
    
    private func onAppear() {
        refreshToken()
    }
    
    func googleSignIn() async throws {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        guard let idToken = result.user.idToken?.tokenString else {
            print("No idToken found.")
            return
        }

        let accessToken = result.user.accessToken.tokenString
        do {
            let result = try await supabase.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(provider: .google,idToken: idToken,accessToken: accessToken)
            )
            
            UserDefaults.standard.set(result.accessToken, forKey: "supabase_access_token")
            UserDefaults.standard.set(result.refreshToken, forKey: "supabase_refresh_token")
        } catch {
            dump(error)
        }
        getUserInfor()
    }
    
    private func refreshToken() {
        Task {
            if let refreshToken = UserDefaults.standard.string(forKey: "supabase_refresh_token") {
//                let newSession = try await supabase.auth.refreshSession(refreshToken: refreshToken)
                let accessToken = UserDefaults.standard.string(forKey: "supabase_access_token")
                let refreshToken = UserDefaults.standard.string(forKey: "supabase_refresh_token")
                
                try await supabase.auth.setSession(accessToken: accessToken ?? "", refreshToken: refreshToken ?? "")
//                UserDefaults.standard.set(newSession.accessToken, forKey: "supabase_access_token")
//                UserDefaults.standard.set(newSession.refreshToken, forKey: "supabase_refresh_token")
                getUserInfor()
            }
        }

    }
    
    private func getUserInfor() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            let userId: String = user.userID ?? ""
            let idToken: String = user.accessToken.tokenString
            let fullName: String = user.profile?.name ?? ""
            let email: String = user.profile?.email ?? ""
            
            if let profilePic: URL = user.profile?.imageURL(withDimension: 200) {
                loadImage(url: profilePic)
                self.user = User(
                    userId: userId,
                    idToken: idToken,
                    fullName: fullName,
                    email: email,
                    profilePic: profilePic
                )
            }
        }
    }
    
    
    private func insertVocab(_ Vocab: Vocab) async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            try await supabase.from("vocabulary").insert(Vocab).select().execute()
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
    
    private func removeVocab() async {
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
    HomeView()
}
