//
//  CarListInteractorTests.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import XCTest
@testable import Cars

final class CarListInteractorTests: XCTestCase {
    private var sut: CarListInteractor!
    private var service: CarListFetchingMock!
    private var presenter: CarListPresentingMock!
    private var expectation: XCTestExpectation!
    
    override func setUp() {
        presenter = CarListPresentingMock()
        service = CarListFetchingMock()
        service.fetchListReturnValue = CarListMockData.createModelMockData()
        sut = CarListInteractor(service: service)
        sut.presenter = presenter
        expectation = expectation(description: "Expectation for \(Self.description())")
    }

    func test_fetch_car_list() async {
        await sut.fetchCars()
        let result = presenter.didFetchCarsResultReceivedResult
        switch result {
        case .success(let data):
            XCTAssert(data.count>0, "Car List not found from interactor")
            expectation.fulfill()
        case .failure(let error):
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        default:
            XCTFail("something went wrong")
            expectation.fulfill()
        }
        await self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    override func tearDown() {
        presenter = nil
        service = nil
        sut = nil
        expectation = nil
    }
}
