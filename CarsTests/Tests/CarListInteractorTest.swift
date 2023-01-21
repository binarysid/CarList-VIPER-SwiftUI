//
//  CarListViewModelTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 22/12/22.
//

import XCTest
import Combine
import CoreData

@testable import Cars

class CarListInteractorTest: XCTestCase {
    var interactor: CarListInteractor!
    var persistenceContainer = CoreDataStackTest.shared.persistentContainer
    var subscriptions = Set<AnyCancellable>()
    var expectation:XCTestExpectation!
    var carRepo = CarLocalRepository()
    let fetchRequest = Car.fetchRequest()
    var dataSourceRepository = MockCarAPIRepository()
    let sourceRequestParam = URLRequest(url: URL(string: "https://google.com")!)
    private var mainContext:NSManagedObjectContext{
        CoreDataStackTest.shared.mainContext
    }
    private var backgroundContext = CoreDataStackTest.shared.backgroundContext

    override class func setUp() {
        DIManager.shared.container.register(NetWorkerProtocol.self) { _  in
            return CarAPIWorker(client: MockCarAPIRepository())
        }
        DIManager.shared.container.register(CarPersistenceWorkerProtocol.self) { _  in
            return CarPersistenceWorker(mainContext: .Main(CoreDataStackTest.shared.mainContext), backgroundContext: .Background(CoreDataStackTest.shared.backgroundContext))
        }
        DIManager.shared.container.register(ReachabilityProtocol.self) { _  in
            return MockNetworkReachability()
        }
    }
    
    override func setUp() {
        interactor = CarListInteractor()
        interactor.presenter = MockCarListPresenter()
        expectation = expectation(description: "Car list expectation")
    }
    override func tearDown() {
        interactor = nil
        expectation = nil
    }

    override class func tearDown() {
        super.tearDown()
        CoreDataStackTest.shared.persistentContainer.destroyPersistentStore()
    }
    
    // simulate network status to check if the right data fetcher called
    func test_fetch_data_online() throws{
        MockNetworkStatus.status = .Available
        interactor.fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0){[unowned self] in
            check_car_list_saved()
            do{
                let apiData = try XCTUnwrap(self.interactor.apiData)
                XCTAssertTrue(apiData.count>0,"API Data empty")
            }catch{
                XCTFail("API Data not found")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // Check if car list saved in persistence store after fetching from server
    func check_car_list_saved(){
        carRepo.getData(fetchRequest, backgroundContext)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion{
                    XCTFail("Local data save failed after async operation due to \(error)")
                }
            }, receiveValue: { data in
                guard data.count>0 else{
                    XCTFail("No local data found. Data saving operation may failed after async operation")
                    return
                }
            })
            .store(in: &subscriptions)
    }
    func test_fetch_data_offline() throws{
        MockNetworkStatus.status = .Offline
        create_mock_car_list() // simulate creating local mock data before invoking fetchdata
        interactor.fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){[unowned self] in
            do{
                let localData = try XCTUnwrap(self.interactor.localData)
                XCTAssertTrue(localData.count>0,"No local Data")
            }catch{
                XCTFail("Local Data not found")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func create_mock_car_list(){
        expectation(forNotification: .NSManagedObjectContextDidSave, object: mainContext) { _ in
            return true
        }
        dataSourceRepository.getData(sourceRequestParam, URLSession.shared)
            .sink(receiveCompletion: {completion in
                if case .failure(let error) = completion{
                    XCTFail(error.errorDescription)
                }
            }, receiveValue: {data in
                self.carRepo.create(data.content.first!, context: self.mainContext){result in
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
