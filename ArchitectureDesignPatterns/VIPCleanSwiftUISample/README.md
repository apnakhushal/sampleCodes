# VIP Clean SwiftUI Sample

This project demonstrates **VIP / Clean Swift Architecture adapted for SwiftUI**.

SwiftUI does not have a long-lived `UIViewController`, so this project uses a `DisplayStore` as the bridge between the SwiftUI View and VIP Clean layers.

## Feature

`ProductList` screen using:

- `SwiftUI View` for rendering UI
- `DisplayStore` as `ObservableObject` and display logic bridge
- `Interactor` for business logic
- `Presenter` for Response → ViewModel formatting
- `Worker` for API/database/cache simulation
- `Router` for SwiftUI navigation state
- `DataStore` for selected data
- `ModuleBuilder` for dependency wiring

## Main Flow

```text
SwiftUI View → DisplayStore → Interactor → Presenter → DisplayStore → SwiftUI View
```

Navigation:

```text
DisplayStore → Router → selectedProduct → NavigationDestination
```

## Teaching Focus

1. SwiftUI View calls `store.fetchProducts()`.
2. DisplayStore creates a `Request`.
3. Interactor performs business logic and creates a `Response`.
4. Presenter converts `Response` into a `ViewModel`.
5. DisplayStore updates `@Published` state.
6. SwiftUI View refreshes automatically.

## How to Run

Open `VIPCleanSwiftUISample.xcodeproj` in Xcode, choose an iPhone simulator, and run.

No third-party dependencies are used.
