//
//  EndPoints.swift
//  GithubUserSearch
//
//  Created by Linkon Sid on 23/3/23.
//

import Foundation
import URLRequestBuilder

enum EndPoints {
    static let baseURL =  "https://" + Config.stringValue(forKey: "BASE_URL")
    static let requestBuilder = URLRequestBuilder()

    case carList

    var request: URLRequest? {
        switch self {
        case .carList:
            let url = EndPoints.baseURL + "/carlist.json"
            return EndPoints.requestBuilder.createRequestWith(baseURL: url)
        }
    }
}
