import Foundation

@MainActor
final class ProductListPresenter: ObservableObject, ProductListPresenterProtocol {

    @Published private(set) var products: [ProductRowViewModel] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let interactor: ProductListInteractorProtocol
    private let router: ProductListRouterProtocol

    private var entities: [Product] = []
    private var hasLoadedOnce = false

    init(
        interactor: ProductListInteractorProtocol,
        router: ProductListRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }

    func onAppear() async {
        guard !hasLoadedOnce else { return }
        hasLoadedOnce = true
        await loadProducts()
    }

    func didTapRefresh() async {
        await loadProducts()
    }

    func didSelectProduct(id: Int) {
        guard let selectedProduct = entities.first(where: { $0.id == id }) else { return }
        router.navigateToProductDetails(product: selectedProduct)
    }

    private func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let products = try await interactor.fetchProducts()
            entities = products
            self.products = products.map(makeViewModel)
        } catch {
            errorMessage = "Unable to load products. Please try again."
        }

        isLoading = false
    }

    private func makeViewModel(from product: Product) -> ProductRowViewModel {
        ProductRowViewModel(
            id: product.id,
            title: product.name,
            subtitle: product.category,
            priceText: "₹\(Int(product.price))",
            ratingText: "⭐️ \(product.rating)"
        )
    }
}
