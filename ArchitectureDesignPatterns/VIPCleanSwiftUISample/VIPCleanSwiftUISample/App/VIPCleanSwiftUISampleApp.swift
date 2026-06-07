import SwiftUI

@main
struct VIPCleanSwiftUISampleApp: App {
    var body: some Scene {
        WindowGroup {
            ProductListView(store: ProductListModuleBuilder.build())
        }
    }
}
