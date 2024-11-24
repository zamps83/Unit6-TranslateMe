// File: TranslationHomeView.swift
import SwiftUI

struct TranslationHomeView: View {
    @StateObject private var viewModel = TranslationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Input Field
                TextField("Enter text to translate", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                // Translate Button
                Button("Translate") {
                    viewModel.translateText()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                // Output Field
                Text("Translated: \(viewModel.translatedText)")
                    .font(.headline)
                    .padding()
                
                Divider()
                
                // History List
                List(viewModel.translationHistory) { translation in
                    VStack(alignment: .leading) {
                        Text("Original: \(translation.originalText)")
                            .font(.subheadline)
                        Text("Translated: \(translation.translatedText)")
                            .font(.headline)
                    }
                }
                
                // Clear History Button
                Button("Clear History") {
                    viewModel.clearHistory()
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .navigationTitle("TranslateMe")
        }
    }
}
