import Foundation

final class ProductListPresenter: ProductListPresentationLogic {
    weak var displayLogic: ProductListDisplayLogic?

    func presentProducts(response: ProductList.FetchProducts.Response) {
        let viewModels = response.products.map { product in
            ProductList.ProductViewModel(
                id: product.id,
                title: product.name,
                subtitle: "\(ProductPriceFormatter.format(product.price)) • \(product.category)",
                availabilityText: product.isAvailable ? "Available" : "Out of Stock"
            )
        }

        let viewModel = ProductList.FetchProducts.ViewModel(products: viewModels)
        displayLogic?.displayProducts(viewModel: viewModel)
    }

    func presentError(response: ProductList.ShowError.Response) {
        let viewModel = ProductList.ShowError.ViewModel(
            title: "Something went wrong",
            message: response.message
        )
        displayLogic?.displayError(viewModel: viewModel)
    }
}
