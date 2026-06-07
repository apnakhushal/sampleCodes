# VIPER SwiftUI Sample

Feature: Product List

VIPER is historically more common in UIKit. This project shows how the same idea can be adapted to SwiftUI.

## VIPER Mapping

- **View**: `ProductListView`
- **Interactor**: `ProductListInteractor`
- **Presenter**: `ProductListPresenter`, implemented as `ObservableObject`
- **Entity**: `Product`
- **Router**: `ProductListRouter`, implemented as `ObservableObject`
- **Builder**: `ProductListModuleBuilder`

## Important teaching point

In SwiftUI, Presenter looks similar to a ViewModel because it owns published UI state.

That is okay for teaching purposes. The key VIPER idea is still visible:

- View only displays state and forwards actions.
- Presenter handles presentation logic.
- Interactor handles business/data logic.
- Router handles navigation state.
- Entity remains pure data.
