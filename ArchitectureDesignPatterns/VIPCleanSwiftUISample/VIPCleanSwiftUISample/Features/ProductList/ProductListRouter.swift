import Foundation

final class ProductListRouter: ProductListRoutingLogic {
    weak var displayStore: ProductListDisplayStore?
    var dataStore: ProductListDataStore?

    func routeToProductDetails() {
        guard let selectedProduct = dataStore?.selectedProduct else { return }
        displayStore?.selectedProduct = selectedProduct
    }
}
