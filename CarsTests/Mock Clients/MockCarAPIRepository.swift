//
//  MockAPIRepository.swift
//  CarsTests
//
//  Created by Linkon Sid on 20/12/22.
//

import Combine
import XCTest
@testable import Cars

// Mock API repository class
final class MockCarAPIRepository:CarAPIClientProtocol{
    
    private let dataSource = "@Mock-ArticleData"
    private let dataSourceWithEmptyData = "@Mock-Empty-ArticleData"

    func getData(_ request: URLRequest,_ context: URLSession) -> AnyPublisher<CarArticleData, APIService.Error> {
        var result: AnyPublisher<CarArticleData, APIService.Error>!
        let testBundle = Bundle(for: CarsTests.self)
        if let url =
            testBundle.url(forResource:dataSource,withExtension:"json"){
            do
            {
                let data = try Data(contentsOf: url)
                let articleData = try JSONDecoder().decode(CarArticleData.self, from: data)
                result = Result.success(articleData).publisher.eraseToAnyPublisher()
            }catch{
                result = Result.failure(APIService.Error.NoDataFound).publisher.eraseToAnyPublisher()
            }
        }
        return result
    }
}
