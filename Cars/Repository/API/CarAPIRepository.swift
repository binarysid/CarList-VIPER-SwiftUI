//
//  APIClient.swift
//  Cars
//
//  Created by Linkon Sid on 18/12/22.
//

import Combine
import Foundation

// fetch data from remote service
final class CarAPIRepository:CarAPIClientProtocol{
    func getData(_ request:URLRequest,_ context:URLSession) -> AnyPublisher<CarArticleData, APIService.Error> {
        context.dataTaskPublisher(for: request)
            .map({ $0.data })
            .decode(type: CarArticleData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError { error in
                    // We map error to present in UI
                    switch error {
                    case is Swift.DecodingError:
                        return APIService.Error.invalidJSON(error as! APIService.Error)
                    default:
                        return APIService.Error.NoDataFound
                    }
                  }
            .eraseToAnyPublisher()
    }
}
