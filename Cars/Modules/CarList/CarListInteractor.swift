//
//  CarInteractor.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import Foundation

class CarListInteractor {
    private var service: CarListService
    var presenter: CarPresenting?
    init(service: CarListService) {
        self.service = service
    }
}

extension CarListInteractor: CarInteracting {
    func fetchCars() async {
        do {
            let cars = try await service.fetchList()
            presenter?.didFetchCars(result: .success(cars))
        } catch {
            
        }
    }
}
