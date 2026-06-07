import Foundation

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

final class ProductService: ProductServiceProtocol {

    func fetchProducts() async throws -> [Product] {
        // Simulates API delay.
        try await Task.sleep(nanoseconds: 600_000_000)

        return [
            Product(id: 1, name: "iPhone 16", category: "Smartphone", price: 79999, rating: 4.8),
            Product(id: 2, name: "MacBook Air", category: "Laptop", price: 114999, rating: 4.7),
            Product(id: 3, name: "AirPods Pro", category: "Audio", price: 24999, rating: 4.6),
            Product(id: 4, name: "Apple Watch", category: "Wearable", price: 41999, rating: 4.5)
        ]
    }
}
