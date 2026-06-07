import Foundation

// MARK: - Interactor

protocol ProductListInteractorProtocol: AnyObject {
    func fetchProducts() async throws -> [Product]
}

// MARK: - Router

@MainActor
protocol ProductListRouterProtocol: AnyObject {
    func navigateToProductDetails(product: Product)
}

// MARK: - Presenter

@MainActor
protocol ProductListPresenterProtocol: AnyObject {
    func onAppear() async
    func didTapRefresh() async
    func didSelectProduct(id: Int)
}
