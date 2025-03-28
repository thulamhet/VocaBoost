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
import CoreData

final class HomeViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var vocabulary: [Vocab] = []
    @Published var isLoading: Bool = false
    @Published var dataInput: String = ""
    @Published var currentWord: WordModel = .init(.null)
    @Published var selectedWord: Vocab?
    @Published var user: User?
    @Published var avatarImage: UIImage?
    @Published var savedVocabulary: [VocabEntity] = []
    
    private lazy var synthesizer = AVSpeechSynthesizer()
    
    init() {
        container = NSPersistentContainer(name: "VocabsContainer")
        container.loadPersistentStores { des, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        fetchVocabsFromLocal()
    }
    
    func fetchVocabsFromLocal() {
        let request = VocabEntity.fetchRequest()
        do {
            savedVocabulary = try container.viewContext.fetch(request)
        } catch {
            dump(error)
        }
    }
    
    func addVocabToLocal(_ vocab: Vocab) {
        if isVocabExist(id: vocab.id.string) {
            return
        }
        
        let newVocab = VocabEntity(context: container.viewContext)
        newVocab.with {
            $0.meaning = vocab.meaning
            $0.name = vocab.name
            $0.phonetic = vocab.phonetic
            $0.type = vocab.type
        }
        saveToLocal()
    }
    
    func deleteVocabFromLocal(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedVocabulary[index]
        container.viewContext.delete(entity)
        saveToLocal()
    }
    
    private func isVocabExist(id: String) -> Bool {
        let request = VocabEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let vocabs = try container.viewContext.fetch(request)
            return !vocabs.isEmpty
        } catch {
            dump(error)
        }
        return false
    }
    
    private func saveToLocal() {
        do {
            try container.viewContext.save()
            fetchVocabsFromLocal()
        } catch {
            dump(error)
        }
    }
    
    @MainActor
    func googleSignIn() async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            guard let idToken = result.user.idToken?.tokenString else {
                print("No idToken found.")
                return
            }
            
            let session = try await supabase.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken))
            let accessToken = session.accessToken
            let refreshToken = session.refreshToken

            UserDefaults.standard.set(accessToken, forKey: "accessToken")
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
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
                DispatchQueue.main.async {
                    self.avatarImage = loadedImage
                }
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
                // id is the order
                let id = vocabulary.count + 1
                try await supabase.from("vocabulary").insert(word.toVocabModel(id: id)).select().execute()
                await fetchVocabulary()
            }
            
            dataInput = ""
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
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
            ErrorManager.showErrorPopup(error.localizedDescription)
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
            self.currentWord.json = convertDataToJSONString(data)
            return self.currentWord
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
        }
        return nil
    }
    
    func convertDataToJSONString(_ data: Data) -> String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    
    @MainActor
    func queryVietnameseWord() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = libreTranslateUrl
            let body: [String: Any] = [
                "q": "elevate",
                "source": "en",
                "target": "vi",
                "format": "text",
                "alternatives": 3,
                "api_key": ""
            ]
            let data = try await NetworkManager.shared.request(url: url, method: .post, body: body)
            print(data)
        } catch {
            ErrorManager.showErrorPopup(error.localizedDescription)
            dump(error)
        }
    }
}
