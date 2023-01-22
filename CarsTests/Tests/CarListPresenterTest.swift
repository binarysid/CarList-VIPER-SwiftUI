//
//  CarListPresenterTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 23/1/23.
//

import XCTest
import Combine
import CoreData
@testable import Cars

class CarListPresenterTest: XCTestCase {
    var sut:CarListPresenter!
    var dataSourceRepository = MockCarAPIRepository()
    let sourceRequestParam = URLRequest(url: URL(string: "https://google.com")!)
    var subscriptions = Set<AnyCancellable>()
    var expectation:XCTestExpectation!
    var persistenceContainer = CoreDataStackTest.shared.persistentContainer
    let fetchRequest = Car.fetchRequest()
    var localRepo = CarLocalRepository()
    private var mainContext:NSManagedObjectContext{
        CoreDataStackTest.shared.mainContext
    }
    private var backgroundContext = CoreDataStackTest.shared.backgroundContext
    
    override func setUp() {
        sut = CarListPresenter()
        let viewState = CarListViewStateMock()
        sut.viewState = viewState
        expectation = expectation(description: "Car List presenter expectation")
    }

    override func tearDown() {
        sut = nil
        expectation = nil
    }

    func test_view_data_from_api_data(){
        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
            .sink(receiveCompletion: {[unowned self] completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                    self.expectation.fulfill()
                }
            }, receiveValue: {[unowned self] data in
                let apiData = data.content
                guard apiData.count>0 else{
                    XCTFail("No API Data found")
                    expectation.fulfill()
                    return
                }
                self.sut.presentViewDataFromAPIData(articles: apiData)
                XCTAssert(self.sut.viewObject.count>0, "Unable to convert and present the api data")
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    func test_view_data_from_local_data(){
        create_mock_car_list()
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0){[unowned self] in
            localRepo.getData(fetchRequest, mainContext)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion{
                        XCTFail(error.errorDescription)
                        expectation.fulfill()
                    }
                }, receiveValue: {data in
                    sut.presentViewDataFromLocalData(cars: data)
                    XCTAssert(sut.viewObject.count>0, "Unable to convert and present the local data")
                    expectation.fulfill()
                })
                .store(in: &subscriptions)
        }
        self.waitForExpectations(timeout: 6.0, handler: nil)
    }
    func create_mock_car_list(){
        expectation(forNotification: .NSManagedObjectContextDidSave, object: mainContext) { _ in
            return true
        }
        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                }
            }, receiveValue: {data in
                self.localRepo.create(data.content.first!, context: self.mainContext){result in
                    switch result{
                    case .success(let car):
                        XCTAssertNotNil(car, PersistenceFailure.DataHandlingError.errorDescription)
                    case .failure(let error):
                        XCTFail(error.errorDescription)
                    }
                }
            })
            .store(in: &subscriptions)
    }

}
