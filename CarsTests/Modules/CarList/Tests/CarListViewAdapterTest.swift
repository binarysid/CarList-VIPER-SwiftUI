//
//  CarListViewAdapterTest.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import XCTest
@testable import Cars

final class CarListViewAdapterTest: XCTestCase {
    private var sut: CarListViewAdapter!
    private var presenter: CarListPresentingMock!
    private var router: CarListRoutingMock!
    private var interactor: CarListInteractingMock!
    private var view: CarListViewOutputMock!
    private var expectation: XCTestExpectation!
    
    override func setUp() {
        router = CarListRoutingMock()
        interactor = CarListInteractingMock()
        view = CarListViewOutputMock()
        presenter = CarListPresentingMock()
        sut = CarListViewAdapter(state: CarListViewState())
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = sut
        interactor.presenter = presenter
        sut.presenter = presenter as? any CarListViewInput
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        router = nil
        interactor = nil
        view = nil
        expectation = nil
        super.tearDown()
    }
}
