import Foundation

final class ProductListInteractor: ProductListBusinessLogic, ProductListDataStore {
    var presenter: ProductListPresentationLogic?

    var products: [Product] = []
    var selectedProduct: Product?

    private let worker: ProductListWorkerProtocol

    init(worker: ProductListWorkerProtocol) {
        self.worker = worker
    }

    func fetchProducts(request: ProductList.FetchProducts.Request) {
        Task {
            do {
                let allProducts = try await worker.fetchProducts()

                let filteredProducts: [Product]
                if let category = request.category, !category.isEmpty {
                    filteredProducts = allProducts.filter { $0.category == category }
                } else {
                    filteredProducts = allProducts
                }

                let response = ProductList.FetchProducts.Response(products: filteredProducts)

                await MainActor.run {
                    self.products = filteredProducts
                    self.presenter?.presentProducts(response: response)
                }
            } catch {
                let response = ProductList.ShowError.Response(
                    message: "Unable to fetch products. Please try again."
                )

                await MainActor.run {
                    self.presenter?.presentError(response: response)
                }
            }
        }
    }

    func selectProduct(id: Int) {
        selectedProduct = products.first { $0.id == id }
    }
}
