//
//  CarInteractor.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import Foundation

class CarListInteractor {
    private var service: CarListFetching
    var presenter: CarListPresenting?
    init(service: CarListFetching) {
        self.service = service
    }
}

// MARK: - Requesting data
extension CarListInteractor: CarListInteracting {
    func fetchCars() async {
        do {
            let cars = try await service.fetchList()
            presenter?.didFetchCars(result: .success(cars))
        } catch {
        }
    }
}
