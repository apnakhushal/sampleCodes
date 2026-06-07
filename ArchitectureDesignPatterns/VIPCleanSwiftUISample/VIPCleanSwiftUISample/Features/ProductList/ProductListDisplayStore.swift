import Foundation

final class ProductListDisplayStore: ObservableObject, ProductListDisplayLogic {
    @Published var products: [ProductList.ProductViewModel] = []
    @Published var isLoading = false
    @Published var errorTitle: String?
    @Published var errorMessage: String?
    @Published var selectedProduct: Product?

    var interactor: ProductListBusinessLogic?
    var router: ProductListRoutingLogic?

    func fetchProducts() {
        isLoading = true
        errorTitle = nil
        errorMessage = nil

        let request = ProductList.FetchProducts.Request(category: nil)
        interactor?.fetchProducts(request: request)
    }

    func didTapProduct(_ productViewModel: ProductList.ProductViewModel) {
        interactor?.selectProduct(id: productViewModel.id)
        router?.routeToProductDetails()
    }

    func displayProducts(viewModel: ProductList.FetchProducts.ViewModel) {
        isLoading = false
        products = viewModel.products
    }

    func displayError(viewModel: ProductList.ShowError.ViewModel) {
        isLoading = false
        errorTitle = viewModel.title
        errorMessage = viewModel.message
    }
}
