import Foundation

final class ProductListWorker: ProductListWorkerProtocol {
    func fetchProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 450_000_000)

        return [
            Product(
                id: 1,
                name: "iPhone 15",
                price: 79999,
                isAvailable: true,
                category: "Smartphone",
                description: "A sample product used to explain VIP Clean in SwiftUI with a Display Store bridge."
            ),
            Product(
                id: 2,
                name: "MacBook Pro",
                price: 199999,
                isAvailable: true,
                category: "Laptop",
                description: "This item demonstrates how Presenter prepares display-ready text for SwiftUI."
            ),
            Product(
                id: 3,
                name: "AirPods Pro",
                price: 24999,
                isAvailable: false,
                category: "Audio",
                description: "This item demonstrates state and availability formatting before UI rendering."
            ),
            Product(
                id: 4,
                name: "iPad Air",
                price: 59999,
                isAvailable: true,
                category: "Tablet",
                description: "This item makes the list more realistic for classroom teaching."
            )
        ]
    }
}
