// File: TranslationViewModel.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class TranslationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var translatedText: String = ""
    @Published var translationHistory: [Translation] = []
    
    private let db = Firestore.firestore()
    private let apiUrl = "https://api.mymemory.translated.net/get"
    
    init() {
        fetchTranslations()
    }
    
    func translateText() {
        guard !inputText.isEmpty else { return }
        
        let params = [
            "q": inputText,
            "langpair": "en|es" // English to Spanish example
        ]
        
        var urlComponents = URLComponents(string: apiUrl)!
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Translation API Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.translatedText = response.responseData.translatedText
                    self?.saveTranslation()
                }
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func saveTranslation() {
        let translation = Translation(
            id: UUID().uuidString,
            originalText: inputText,
            translatedText: translatedText,
            timestamp: Date()
        )
        
        do {
            try db.collection("translations").document(translation.id).setData(from: translation)
            fetchTranslations()
        } catch {
            print("Firestore Save Error: \(error)")
        }
    }
    
    func fetchTranslations() {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Fetch Error: \(error.localizedDescription)")
                    return
                }
                
                self?.translationHistory = snapshot?.documents.compactMap {
                    try? $0.data(as: Translation.self)
                } ?? []
            }
    }
    
    func clearHistory() {
        db.collection("translations").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error clearing history: \(error)")
                return
            }
            
            snapshot?.documents.forEach { $0.reference.delete() }
            self?.translationHistory = []
        }
    }
}
