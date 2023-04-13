//
//  CarRouter.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import SwiftUI

final class CarListRouter: CarListRouting {
    /// Wiring VIPER Cycle
    static func createModule() -> some View {
        let service = CarListService()
        let interactor = CarListInteractor(service: service)
        let presenter = CarListPresenter()
        let router = CarListRouter()
        let adapter = CarListViewAdapter(state: CarListViewState())
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = adapter
        interactor.presenter = presenter
        adapter.presenter = presenter
        return CarListView(adapter: adapter)
    }

    func makeDetailView(with data: CarViewData) -> CarDetailView {
        CarDetailView(details: data)
    }
}
