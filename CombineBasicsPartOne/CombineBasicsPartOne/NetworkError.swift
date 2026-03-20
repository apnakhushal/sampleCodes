//
//  NetworkError.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 14/03/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case addressNotFound
    case decodingError(Error)
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: "The server gave a bad response."
        case .addressNotFound: "Check your internet connection."
        case .decodingError(let err): "JSON Mismatch: \(err.localizedDescription)"
        case .invalidURL: "Invalid URL"
        }
    }
}
