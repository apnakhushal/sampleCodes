import Foundation

// Entity
// Pure data model. No SwiftUI or UIKit dependency.
struct Product: Identifiable, Decodable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let rating: Double
}

// View-friendly model prepared by Presenter.
struct ProductRowViewModel: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let priceText: String
    let ratingText: String
}
