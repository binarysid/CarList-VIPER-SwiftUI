//
//  CarListModelMockData.swift
//  CarsTests
//
//  Created by Linkon Sid on 18/4/23.
//

import Foundation
@testable import Cars

enum CarListMockData {
    static let url = TestConfig.bundle.url(forResource:"@Mock-ArticleData",withExtension:"json")!
    static let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: nil)!
    
    static func createModelRawData() -> Data {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
    }
    
    static func createModelMockData() -> [CarData] {
        
        do {
            let data = createModelRawData()
            let userData = try JSONDecoder().decode(CarArticleData.self, from: data)
            return userData.content
        } catch {
            return []
        }
    }
    
    static func createViewMockData() -> [CarViewData] {
        let data = createModelMockData()
        guard data.count > 0 else { return [] }
        return data.map {
            guard let date = $0.dateTime.toDate() else {
                return CarViewData(id: $0.id, title: $0.title, image: $0.image, description: $0.content.description, date: "", time: "")
            }
            return CarViewData(id: $0.id, title: $0.title, image: $0.image, description: $0.content.description, date: date.getMonthName(), time: "\(date.getTime().hour)")
        }
    }
}
