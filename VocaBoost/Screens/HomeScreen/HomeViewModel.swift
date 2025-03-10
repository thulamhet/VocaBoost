//
//  HomeViewModel.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 10/3/25.
//
import Supabase
import AVFoundation
import GoogleSignIn
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var vocabulary: [Vocab] = []
    @Published var isLoading: Bool = false
    @Published var dataInput: String = ""
    @Published var currentWord: WordModel = .init(.null)
    @Published var selectedWord: Vocab?
    @Published var user: User?
    @Published var avatarImage: UIImage?
    
    private lazy var synthesizer = AVSpeechSynthesizer()
    
    @MainActor
    func googleSignIn() async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            guard (result.user.idToken?.tokenString) != nil else {
                print("No idToken found.")
                return
            }
        } catch {
            dump(error)
        }
        getUserInfor()
    }
    
    @MainActor
    func getUserInfor() {
        isLoading = true
        defer { isLoading = false }
        
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
    
    @MainActor
    func loadImage(url: URL) {
        isLoading = true
        defer { isLoading = false }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                self.avatarImage = loadedImage
            }
        }
        task.resume()
    }
    
    @MainActor
    func insertVocab() async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            if let word = await inquiryWordInfor() {
                try await supabase.from("vocabulary").insert(word.toVocabModel()).select().execute()
                await fetchVocabulary()
            }
            
            dataInput = ""
        } catch {
            dump(error)
        }
    }
    
    @MainActor
    func fetchVocabulary() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            vocabulary = try await supabase.from("vocabulary").select().execute().value
        } catch {
            dump(error)
        }
    }
    
    func removeVocab() async {
        isLoading = true
        defer { isLoading = false }
        
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
    
    func updateData() async {
        isLoading = true
        defer { isLoading = false }
        
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
    
    func deleteAllRow() async {
        isLoading = true
        defer { isLoading = false }
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
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // English voice
        synthesizer.speak(utterance)
    }
    
    @MainActor
    func inquiryWordInfor() async -> WordModel? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = "\(apiDictionaryUrl)\(dataInput.lowercased())"
            let data = try await NetworkManager.shared.request(url: url)
            let decoder = JSONDecoder()
            let words = try decoder.decode([WordModel].self, from: data)
            self.currentWord = words.first ?? .init(.null)
            return words.first
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
            
        }
        return nil
    }
}
