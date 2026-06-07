import Foundation

struct Product: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let price: Double
    let isAvailable: Bool
    let category: String
    let description: String
}
