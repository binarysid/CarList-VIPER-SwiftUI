//
//  CarListPresenterTests.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import XCTest
@testable import Cars

final class CarListPresenterTests: XCTestCase {
    private var sut: CarListPresenter!
    private var router: CarListRoutingMock!
    private var interactor: CarListInteractingMock!
    private var view: CarListViewOutputMock!
    private var expectation: XCTestExpectation!
    private var mockData = CarListMockData.createModelMockData()
    private var mockViewData = CarListMockData.createViewMockData()
    
    override func setUp() {
        router = CarListRoutingMock()
        interactor = CarListInteractingMock()
        view = CarListViewOutputMock()
        sut = CarListPresenter()
        sut.router = router
        sut.interactor = interactor
        sut.view = view
        interactor.presenter = sut
        expectation = expectation(description: "Expectation for \(Self.description())")
        super.setUp()
    }

    func test_fetch_car_list() async {
        interactor.fetchCarsClosure = {
            self.interactor.presenter?.didFetchCars(result: .success(self.mockData))
        }
        await sut.fetchCarList()
        do {
            let viewData = try XCTUnwrap(view.updateDataReceivedData)
            XCTAssert(viewData.count > 0, "From Model to ViewData conversion failed")
            expectation.fulfill()
        } catch {
            XCTFail("Unwrapping failed")
            expectation.fulfill()
        }
        await self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    func test_make_detail_view() {
        do {
            let data = try XCTUnwrap(mockViewData.first)
            let detailView = sut.makeDetailView(with: data)
            XCTAssert(detailView != nil, "View creation failed")
            expectation.fulfill()
        } catch {
            XCTFail("Unwrapping failed")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    override func tearDown() {
        router = nil
        interactor = nil
        view = nil
        sut = nil
        super.tearDown()
    }
}
