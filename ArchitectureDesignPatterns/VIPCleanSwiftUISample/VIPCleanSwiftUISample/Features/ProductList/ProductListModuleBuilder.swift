enum ProductListModuleBuilder {
    static func build() -> ProductListDisplayStore {
        let displayStore = ProductListDisplayStore()
        let worker = ProductListWorker()
        let interactor = ProductListInteractor(worker: worker)
        let presenter = ProductListPresenter()
        let router = ProductListRouter()

        displayStore.interactor = interactor
        displayStore.router = router

        interactor.presenter = presenter
        presenter.displayLogic = displayStore

        router.displayStore = displayStore
        router.dataStore = interactor

        return displayStore
    }
}
