protocol ProductListDisplayLogic: AnyObject {
    func displayProducts(viewModel: ProductList.FetchProducts.ViewModel)
    func displayError(viewModel: ProductList.ShowError.ViewModel)
}

protocol ProductListBusinessLogic: AnyObject {
    func fetchProducts(request: ProductList.FetchProducts.Request)
    func selectProduct(id: Int)
}

protocol ProductListPresentationLogic: AnyObject {
    func presentProducts(response: ProductList.FetchProducts.Response)
    func presentError(response: ProductList.ShowError.Response)
}

protocol ProductListRoutingLogic: AnyObject {
    func routeToProductDetails()
}

protocol ProductListDataStore: AnyObject {
    var products: [Product] { get set }
    var selectedProduct: Product? { get set }
}

protocol ProductListWorkerProtocol: AnyObject {
    func fetchProducts() async throws -> [Product]
}
