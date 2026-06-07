enum ProductList {
    enum FetchProducts {
        struct Request {
            let category: String?
        }

        struct Response {
            let products: [Product]
        }

        struct ViewModel {
            let products: [ProductViewModel]
        }
    }

    enum ShowError {
        struct Response {
            let message: String
        }

        struct ViewModel {
            let title: String
            let message: String
        }
    }

    struct ProductViewModel: Identifiable, Hashable {
        let id: Int
        let title: String
        let subtitle: String
        let availabilityText: String
    }
}
