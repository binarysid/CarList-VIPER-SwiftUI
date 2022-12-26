//
//  CarListViewModel.swift
//  Cars
//  Created by Linkon Sid on 16/12/22.
//

import Combine
import Swinject
import Reachability
import CombineReachability
import Foundation

// this class acts as Brain/Interactor for the project. Receives request from View, communicates with different workers to get and process the data and provides the data to the subscriber
final class CarListViewModel:ObservableObject{

    @Inject
    private var apiWorker: NetWorkerProtocol
    @Inject
    private var persistenceWorker: CarPersistenceWorkerProtocol
    @Inject
    private var dataWorker:CarDataWorkerProtocol
    @Published var viewObject:[CarViewData] = []
    @Published var showLoader = false
    @Published var showError = false
    var subscriptions = Set<AnyCancellable>()
    var reachability: Reachability?
    init() {
        do{
            reachability = try Reachability()
            try? reachability?.startNotifier()
        }
        catch{
            print("error")
        }
    }
    deinit{
        reachability?.stopNotifier()
    }
    func fetchData(){
        // check if network connection changes
        reachability?.reachabilityChanged
          .sink(receiveValue: {[unowned self] reachability in
              if reachability.connection != .unavailable {
                  self.getCarListFromAPI()
              }
              else if self.viewObject.count==0{// if the device is offline then fetch data from cache
                  self.getCarListFromLocalDB()
              }
          })
          .store(in: &subscriptions)
    }
    private func getCarListFromAPI(){
        self.showLoader = true
        // subscribe to api worker for data
        self.apiWorker.resultPublisher
            .map{[weak self] item->[CarViewData]? in
                guard let self = self else{
                    return nil
                }
                // after successfully retrieving data, saving it to local store
                self.persistenceWorker.save(from: item)
                // converting api data to presentable data
                return self.dataWorker.processViewDataFrom(articles: item)
            }
            .sink(receiveCompletion: {[weak self] completion in
                self?.showLoader = false
                if case .failure(_) = completion{
                    self?.showError = true
                }
            }, receiveValue: {[weak self] data in
                guard let domainObject = data else{
                    return
                }
                self?.setViewObject(domainObject)
            })
            .store(in: &subscriptions)
        self.apiWorker.requestForDomainData()
    }
    private func getCarListFromLocalDB(){
        self.showLoader = true
        // subscribe to persistence worker for data
        self.persistenceWorker.publisher
            .map{ [unowned self] data in
                // converting cached data to presentable data
                self.dataWorker.processViewDataFrom(cars: data)
            }
            .sink(
                receiveCompletion: {[weak self] completion in
                    self?.showLoader = false
                    if case .failure(_) = completion{
                        print("failed")
                    }
                }, receiveValue: {[weak self] domainObject in
                    self?.setViewObject(domainObject)
                })
            .store(in: &subscriptions)
        self.persistenceWorker.fetchList()
    }
}
extension CarListViewModel{
    private func setViewObject(_ data:[CarViewData]) {
        self.viewObject = data
    }
}
