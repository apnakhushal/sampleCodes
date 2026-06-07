import Foundation

@MainActor
final class ProductListRouter: ObservableObject, ProductListRouterProtocol {

    @Published var selectedProduct: Product?

    func navigateToProductDetails(product: Product) {
        selectedProduct = product
    }
}
