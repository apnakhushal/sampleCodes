import SwiftUI

struct ProductDetailsView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(product.name)
                .font(.largeTitle.bold())

            Text(product.category)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(ProductPriceFormatter.format(product.price))
                .font(.title2.bold())

            Text(product.isAvailable ? "Available" : "Out of Stock")
                .font(.subheadline.bold())
                .foregroundStyle(product.isAvailable ? .green : .red)

            Divider()

            Text(product.description)
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
