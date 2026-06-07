import SwiftUI

@MainActor
final class ProductListModuleBuilder {

    static func build() -> ProductListView {
        let service = ProductService()
        let interactor = ProductListInteractor(service: service)
        let router = ProductListRouter()

        let presenter = ProductListPresenter(
            interactor: interactor,
            router: router
        )

        return ProductListView(
            presenter: presenter,
            router: router
        )
    }
}
