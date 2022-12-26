//
//  APIClientProtocol.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//

import Combine
import Foundation

protocol CarAPIClientProtocol:RepositoryProtocol where Request == URLRequest, Output == AnyPublisher<CarArticleData,APIService.Error>, Context == URLSession {
    func getData(_ request:URLRequest,_ context:URLSession) -> AnyPublisher<CarArticleData,APIService.Error>
}
