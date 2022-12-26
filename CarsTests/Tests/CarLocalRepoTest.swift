//
//  CarLocalRepoTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 19/12/22.
//

import XCTest
import Combine
import CoreData
@testable import Cars

class CarLocalRepoTest: XCTestCase {
    var carRepo = CarLocalRepository()
    var dataSourceRepository = MockCarAPIRepository()
    var expectation: XCTestExpectation!
    var subscriptions = Set<AnyCancellable>()
    var persistenceContainer = CoreDataStackTest.shared.persistentContainer
    let sourceRequestParam = URLRequest(url: URL(string: "https://google.com")!)
    let fetchRequest = Car.fetchRequest()
    var dataWorker = CarDataWorker()

    private var mainContext:NSManagedObjectContext{
        CoreDataStackTest.shared.mainContext
    }
    private var backgroundContext = CoreDataStackTest.shared.backgroundContext
    
    override func setUp() {
        super.setUp()
//        carRepo = CarLocalRepository()
//        dataSourceRepository = MockCarAPIRepository()
        expectation = expectation(description: "Car local store expectation")
    }
    override func tearDown() {
//        carRepo = nil
//        dataSourceRepository = nil
        expectation = nil
    }
    func test_create_car(){
        expectation(forNotification: .NSManagedObjectContextDidSave, object: mainContext) { _ in
            return true
        }
        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
            .sink(receiveCompletion: {completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                    self.expectation.fulfill()
                }
            }, receiveValue: {data in
                self.carRepo.create(data.content.first!, context: self.mainContext){result in
                    switch result{
                    case .success(let car):
                        XCTAssertNotNil(car, PersistenceFailure.DataHandlingError.errorDescription)
                        self.expectation.fulfill()
                    case .failure(let error):
                        XCTFail(error.errorDescription)
                        self.expectation.fulfill()
                    }
                }
            })
            .store(in: &subscriptions)
        self.waitForExpectations(timeout: 2.0){ error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    func test_fetch_car(){
        carRepo.getData(fetchRequest, mainContext)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                    self?.expectation.fulfill()
                }
            }, receiveValue: {[weak self] data in
                guard let car = data.first else{
                    XCTFail("No Data Found")
                    self?.expectation.fulfill()
                    return
                }
                XCTAssertFalse(car.title.isEmpty, "No title Found")
                XCTAssertNotNil(car.image, "No Image found")
                XCTAssertFalse(car.ingress.isEmpty, "No ingress Found")
                XCTAssertNotNil(car.date, "No Date found")
                self?.expectation.fulfill()
            })
            .store(in: &subscriptions)
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
//    func test_update_car(){
//        expectation(forNotification: .NSManagedObjectContextDidSave, object: mainContext) { _ in
//            return true
//        }
//        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
//            .sink(receiveCompletion: {completion in
//                if case .failure(let error) = completion{
//                    XCTFail(error.errorDescription)
//                    self.expectation.fulfill()
//                }
//            }, receiveValue: {[unowned self] data in
//                let carData = data.content.first!
//                self.carRepo.create(carData, context: self.mainContext){[unowned self] result in
//                    switch result{
//                    case .success(let car):
//                        XCTAssertNotNil(car, PersistenceFailure.FailedToSave.errorDescription)
//                        self.carRepo.updateEntity(from: carData, to: car, context: self.mainContext){[unowned self] result in
//                            switch result{
//                            case .success(let car):
//                                XCTAssertNotNil(car, PersistenceFailure.FailedToSave.errorDescription)
//                                self.expectation.fulfill()
//                            case .failure(let error):
//                                XCTFail(error.errorDescription)
//                                self.expectation.fulfill()
//                            }
//                        }
//
//                    case .failure(let error):
//                        XCTFail(error.errorDescription)
//                        self.expectation.fulfill()
//                    }
//                }
//            })
//            .store(in: &subscriptions)
//        self.waitForExpectations(timeout: 0.0,handler: nil)
//    }

    func test_data_worker(){
        carRepo.getData(fetchRequest, backgroundContext)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                    self?.expectation.fulfill()
                }
            }, receiveValue: {[unowned self] data in
                guard data.count>0 else{
                    XCTFail("No Data Found")
                    return
                }
                let viewData = self.dataWorker.processViewDataFrom(cars: data)
                guard let item = viewData.first else {
                    XCTFail("View Data not Found")
                    return
                }
                XCTAssertFalse(item.title.isEmpty, "No title Found")
                XCTAssertNotNil(item.image, "No Image found")
                XCTAssertFalse(item.description.isEmpty, "No description Found")
                XCTAssertNotNil(item.date, "No Date found")
                self.expectation.fulfill()
            })
            .store(in: &subscriptions)
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
//    func test_create_car_list(){
//        expectation(forNotification: .NSManagedObjectContextDidSave, object: backgroundContext) { _ in
//            return true
//        }
//        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
//            .sink(receiveCompletion: {completion in
//                if case .failure(let error) = completion{
//                    XCTFail(error.errorDescription)
//                    self.expectation.fulfill()
//                }
//            }, receiveValue: {data in
//                for item in data.content{
//                    self.carRepo.create(item, context:self.mainContext){result in
//                        switch result{
//                        case .success(let car):
//                            XCTAssertNotNil(car, PersistenceFailure.DataHandlingError.errorDescription)
//                            self.expectation.fulfill()
//                        case .failure(let error):
//                            XCTFail(error.errorDescription)
//                            self.expectation.fulfill()
//                        }
//                    }
//                }
////                self.expectation.fulfill()
//            })
//            .store(in: &subscriptions)
//        self.waitForExpectations(timeout: 0.0){ error in
//            XCTAssertNil(error, "Save did not occur")
//        }
//    }
    override class func tearDown() {
        super.tearDown()
        CoreDataStackTest.shared.persistentContainer.destroyPersistentStore()
    }
}
