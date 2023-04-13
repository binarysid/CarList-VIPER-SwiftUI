//
//  CarListService.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import Foundation
import WebService // this package has been developed by the author for reusablity purpose

struct CarListService: WebService {
    func fetchList() async throws -> [CarData] {
        do {
            guard let request = EndPoints.carList.request else {
                throw NetworkError.badURL
            }
            let (data, response) = try await fetch(request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serviceNotFound
            }
            let result = try decode(type: CarArticleData.self, from: data)
            guard result.content.count > 0 else { throw NetworkError.noDataFound }
            return result.content
        } catch {
            throw NetworkError.invalidJson
        }
    }
}
