//
//  CarListContract.swift
//  Cars
//
//  Created by Linkon Sid on 13/4/23.
//

import SwiftUI

// All the delegates required to connect VIPER components
// Contracts between the components wired through the router

// MARK: - Presenter to View
// sourcery: AutoMockable
protocol CarListViewOutput: Loadable, AnyObject {
    func update(data: [CarViewData])
    func update(error: String)
}

// MARK: - View to Presenter
// sourcery: AutoMockable
protocol CarListViewInput {
    func fetchCarList() async
    func makeDetailView(with data: CarViewData) -> CarDetailView?
}

// MARK: - Presenter
// sourcery: AutoMockable
protocol CarListPresenting {
    func didFetchCars(result: Result<[CarData], NetworkError>)
}

// MARK: - Router
protocol CarListRouting {
    associatedtype T: View
    static func createModule() -> T
    func makeDetailView(with data: CarViewData) -> CarDetailView
}

// MARK: - Interactor
// sourcery: AutoMockable
protocol CarListInteracting {
    func fetchCars() async
}

// MARK: - ListFetch Service
// sourcery: AutoMockable
protocol CarListFetching {
    func fetchList() async throws -> [CarData]
}
