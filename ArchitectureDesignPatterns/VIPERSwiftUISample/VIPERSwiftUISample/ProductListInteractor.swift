import Foundation

final class ProductListInteractor: ProductListInteractorProtocol {

    private let service: ProductServiceProtocol

    init(service: ProductServiceProtocol) {
        self.service = service
    }

    func fetchProducts() async throws -> [Product] {
        try await service.fetchProducts()
    }
}
