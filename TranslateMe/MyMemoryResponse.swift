// File: MyMemoryResponse.swift
import Foundation

struct MyMemoryResponse: Codable {
    let responseData: ResponseData
    
    struct ResponseData: Codable {
        let translatedText: String
    }
}
