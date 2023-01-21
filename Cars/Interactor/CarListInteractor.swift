//
//  CarListViewModel.swift
//  Cars
//  Created by Linkon Sid on 16/12/22.
//

import Combine
import Swinject
import Foundation

protocol CarListInteractorInput{
    func fetchData()
}
// This class acts as Brain of the project. Receives request from View, communicates with different workers to get and process the data and sends the data to the presenter
final class CarListInteractor{

    @Inject
    private var apiWorker: NetWorkerProtocol
    @Inject
    private var persistenceWorker: CarPersistenceWorkerProtocol
    @Inject
    private var networkReachability: ReachabilityProtocol
    private var subscriptions = Set<AnyCancellable>()
    var presenter:CarListPresentable!
    private(set) var apiData:[CarData]?{ //private(set) makes the property read-only for outsider classes
        didSet{
            if let data = apiData{
                self.persistenceWorker.save(from: data)
                self.presenter.processViewDataFrom(articles: data)
            }
        }
    }
    private(set) var localData:[Car]?{
        didSet{
            if let data = localData{
                self.presenter.processViewDataFrom(cars: data)
            }
        }
    }
    private func getCarListFromAPI(){
        self.presenter.showLoader()
        // subscribe to api worker for data
        self.apiWorker.resultPublisher
            .sink(receiveCompletion: {[weak self] completion in
                self?.presenter.hideLoader()
                if case .failure(_) = completion{
                    self?.presenter.showError()
                }
            }, receiveValue: {[weak self] data in
                self?.apiData = data
            })
            .store(in: &subscriptions)
        self.apiWorker.requestForDomainData()
    }
    private func getCarListFromLocalDB(){
        self.presenter.showLoader()
        // subscribe to persistence worker for data
        self.persistenceWorker.publisher
            .sink(
                receiveCompletion: {[weak self] completion in
                    self?.presenter.hideLoader()
                    if case .failure(_) = completion{
                        self?.presenter.showError()
                    }
                }, receiveValue: {[weak self] data in
                    self?.localData = data
                })
            .store(in: &subscriptions)
        self.persistenceWorker.fetchList()
    }
}

extension CarListInteractor:CarListInteractorInput{
    func fetchData(){
        networkReachability
                .statusPublisher
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] status in
                    if status == .Available {
                        self.getCarListFromAPI()
                    }
                    else if status == .Offline &&  !self.presenter.hasViewData(){// if no data exists and the device is offline then fetch data from cache
                        self.getCarListFromLocalDB()
                    }
            }
                .store(in: &subscriptions)
        networkReachability.checkReachability()
    }
}
