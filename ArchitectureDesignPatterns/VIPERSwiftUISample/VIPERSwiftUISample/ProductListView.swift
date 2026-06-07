import SwiftUI

struct ProductListView: View {

    @StateObject private var presenter: ProductListPresenter
    @StateObject private var router: ProductListRouter

    init(
        presenter: ProductListPresenter,
        router: ProductListRouter
    ) {
        _presenter = StateObject(wrappedValue: presenter)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("VIPER SwiftUI")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Refresh") {
                            Task {
                                await presenter.didTapRefresh()
                            }
                        }
                    }
                }
                .task {
                    await presenter.onAppear()
                }
                .sheet(item: $router.selectedProduct) { product in
                    NavigationStack {
                        ProductDetailView(product: product)
                    }
                }
                .alert(
                    "Error",
                    isPresented: Binding(
                        get: { presenter.errorMessage != nil },
                        set: { if !$0 { presenter.errorMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(presenter.errorMessage ?? "Something went wrong.")
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if presenter.isLoading && presenter.products.isEmpty {
            ProgressView("Loading products...")
        } else {
            List(presenter.products) { product in
                Button {
                    presenter.didSelectProduct(id: product.id)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.title)
                            .font(.headline)

                        Text("\(product.subtitle) • \(product.priceText) • \(product.ratingText)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .overlay {
                if presenter.isLoading {
                    ProgressView()
                }
            }
        }
    }
}
