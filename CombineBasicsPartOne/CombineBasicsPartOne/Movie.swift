//
//  Movie.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 14/03/2026.
//

import Foundation

struct Movie: Codable, Hashable, Equatable {
    let id: String?
    let type: String?
    let primaryTitle: String?
    let originalTitle: String?
    let primaryImage: PrimaryImage?
    let startYear: Int?
    let rating: Rating?
}

struct PrimaryImage: Codable {
    let url: String?
    let width: Int?
    let height: Int?
}

struct Rating: Codable {
    let aggregateRating: Double?
    let voteCount: Int?
}

extension Movie {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SearchMovieResponse: Decodable {
    let titles: [Movie]
}
