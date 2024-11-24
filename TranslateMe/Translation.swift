// File: Translation.swift
import Foundation

struct Translation: Codable, Identifiable {
    let id: String
    let originalText: String
    let translatedText: String
    let timestamp: Date
}
