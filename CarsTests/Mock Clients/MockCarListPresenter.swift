//
//  MockPresenter.swift
//  CarsTests
//
//  Created by Linkon Sid on 21/1/23.
//

@testable import Cars
import Combine

final class MockCarListPresenter:CarListPresentable{
    var apiDataPresenterCalled = false
    var localDataPresenterCalled = false
    var hasError = false
    var isLoaderVisible = false
   
    func processViewDataFrom(articles: [CarData]) {
        apiDataPresenterCalled = true
    }
    
    func processViewDataFrom(cars: [Car]) {
        localDataPresenterCalled = true
    }
    
    func hasViewData() -> Bool {
        localDataPresenterCalled || localDataPresenterCalled
    }
    
    func showError() {
        hasError = true
    }
    
    func showLoader() {
        isLoaderVisible = true
    }
    
    func hideLoader() {
        isLoaderVisible = false
    }
    
    
}
