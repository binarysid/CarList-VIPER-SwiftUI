//
//  CarPersistenceWorker.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//
import Foundation
import Combine

protocol CarPersistenceWorkerProtocol{
    var publisher:PassthroughSubject<[Car],PersistenceFailure>{
        get set
    }
    func fetchList()
    func save(from data:[CarData])
}

/**
 The worker receives data request from **View Model**, call **Core Data Repository** for **CRUD** operation,decide which context the operation will run on, extract anything necessary from the core data object and Pass the data to View Model.
 
 
 * **Example to initialize**
 ```
 CarPersistenceWorker(mainContext: mainContext, backgroundContext: backgroundContext)
 ```
 
 */
final class CarPersistenceWorker:CarPersistenceWorkerProtocol{
    var publisher = PassthroughSubject<[Car],PersistenceFailure>()
    var carRepository = CarLocalRepository()
    private var subscriptions = Set<AnyCancellable>()
    private var fetchRequest = PersistenceService.Entity.CarList.FetchRequest
    typealias Context = PersistenceService.Context.type
    private var mainContext:Context!
    private var backgroundContext:Context!
    init(mainContext:PersistenceService.Context,backgroundContext:PersistenceService.Context) {
        self.mainContext = mainContext.value
        self.backgroundContext = backgroundContext.value
    }
    func fetchList() {
        self.carRepository.getData(fetchRequest, mainContext)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(let error) = completion{
                    self?.publisher.send(completion: .failure(error))
                }
            }, receiveValue: {[weak self] data in
                self?.publisher.send(data)
                self?.publisher.send(completion: .finished)
            })
            .store(in: &subscriptions)
    }

    func save(from data: [CarData]) {
        self.carRepository.getData(fetchRequest, backgroundContext)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.global(qos: .utility))
            .sink(
                receiveCompletion: {[weak self] completion in
                    if case .failure(let error) = completion,error == .NoDataFound,let self = self{
                        self.createEntities(from: data)
                    }
                }, receiveValue: {cars in
                    self.updateEntitiesWithOptimization(from: data, to: cars)
                }
            )
            .store(in: &subscriptions)
    }
}

extension CarPersistenceWorker{
    private func createEntities(from data:[CarData]){
        for item in data{
            // passing remote data to api repository to store in cache
            self.carRepository.create(item, context: backgroundContext){_ in}
        }
    }
    
    // Time complexity: O(n)
    // Extra Space: O(n)
    // Extra space is used to optimize time complexity
    private func updateEntitiesWithOptimization(from items:[CarData],to data:[Car]){
        var dataDict:[Int64:Car] = [:]
        for obj in data{
            dataDict[obj.id] = obj
        }
        for item in items{
            // if any item found then it will be updated. otherwise new item will be created in cache
            if let car = dataDict[item.id]{
                carRepository.updateEntity(from: item, to: car, context: mainContext){_ in}
            }
            else{
                self.carRepository.create(item, context: backgroundContext){_ in}
            }
        }
    }
    
    // Time complexity: O(n^2)
    private func updateEntities(from items:[CarData]){
        for item in items{
            // if any item found then it will be updated. otherwise new item will be created in cache
            if let car = carRepository.fetchEntityBy(item.id, request: fetchRequest, context: backgroundContext){
                carRepository.updateEntity(from: item, to: car, context: backgroundContext){_ in
                }
            }
            else{
                self.carRepository.create(item, context: backgroundContext){_ in}
            }
        }
    }
}

