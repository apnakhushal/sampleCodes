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
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server gave a bad response."
        case .addressNotFound: return "Check your internet connection."
        case .decodingError(let err): return "JSON Mismatch: \(err.localizedDescription)"
        }
    }
}
