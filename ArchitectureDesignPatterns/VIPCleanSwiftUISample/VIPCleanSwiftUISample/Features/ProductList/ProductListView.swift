import SwiftUI

struct ProductListView: View {
    @StateObject var store: ProductListDisplayStore

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("VIP Clean SwiftUI")
                .task {
                    if store.products.isEmpty {
                        store.fetchProducts()
                    }
                }
                .refreshable {
                    store.fetchProducts()
                }
                .navigationDestination(item: $store.selectedProduct) { product in
                    ProductDetailsView(product: product)
                }
                .alert(
                    store.errorTitle ?? "Error",
                    isPresented: Binding(
                        get: { store.errorMessage != nil },
                        set: { newValue in
                            if !newValue {
                                store.errorTitle = nil
                                store.errorMessage = nil
                            }
                        }
                    )
                ) {
                    Button("OK", role: .cancel) {
                        store.errorTitle = nil
                        store.errorMessage = nil
                    }
                } message: {
                    Text(store.errorMessage ?? "")
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            VStack(spacing: 12) {
                ProgressView()
                Text("Loading products...")
                    .foregroundStyle(.secondary)
            }
        } else {
            List(store.products) { product in
                Button {
                    store.didTapProduct(product)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(product.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(product.availabilityText)
                            .font(.caption.bold())
                            .foregroundStyle(product.availabilityText == "Available" ? .green : .red)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }
}
