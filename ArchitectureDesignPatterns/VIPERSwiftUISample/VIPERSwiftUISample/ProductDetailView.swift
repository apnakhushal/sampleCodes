import SwiftUI

struct ProductDetailView: View {

    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(product.name)
                .font(.largeTitle)
                .bold()

            Text("Category: \(product.category)")
                .font(.title3)

            Text("Price: ₹\(Int(product.price))")
                .font(.title3)

            Text("Rating: ⭐️ \(product.rating)")
                .font(.title3)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
