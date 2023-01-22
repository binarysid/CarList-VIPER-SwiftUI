//
//  CarAPIWorker.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//

import Combine
import Foundation

protocol NetWorkerProtocol{
    var resultPublisher:PassthroughSubject<[CarData],APIService.Error>{
        get set
    }
    func requestForDomainData()
}
// All network calls are managed by this class
final class CarAPIWorker<T:CarAPIClientProtocol>:NetWorkerProtocol{
    var subscriptions = Set<AnyCancellable>()
    var resultPublisher = PassthroughSubject<[CarData], APIService.Error>()
    var apiRepository:T?
    init(client:T) {
        self.apiRepository = client
    }
    func requestForDomainData(){
        guard let url = APIService.EndPoints.CarList.url else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = APIService.HTTPMethods.GET
        apiRepository?.getData(urlRequest, URLSession.shared)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion{
                    self?.resultPublisher.send(completion: .failure(.NoDataFound))
                }
                
            }, receiveValue: {[weak self] data in
                self?.resultPublisher.send(data.content)
                self?.resultPublisher.send(completion: .finished)
            })
            .store(in: &subscriptions)
    }
}
