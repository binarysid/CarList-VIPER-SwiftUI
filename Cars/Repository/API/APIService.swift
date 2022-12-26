//
//  API.swift
//  Cars
//
//  Created by Linkon Sid on 19/12/22.
//

import Foundation

// this struct holds all config required for network calls
struct APIService{
    enum HTTPMethods{
        static let GET = "GET"
        static let POST = "POST"
    }
    /**
     Swift has built-in protocol named Error. So to use the same name in our enum we used indirect. this instructs the compiler to store the enum’s data to a pointer.
     
     - **Reference**
       - [Read this](https://daniilspirit.medium.com/indirect-enums-on-practice-58610c9db2ac)
     
     */
    indirect enum Error:RepositoryError{
        case ServiceNotFound
        case BadURL
        case NoDataFound
        case duplicate
        case invalidResponse(URLResponse?)
        case invalidJSON(Error)
        var noData: APIService.Error{
            .NoDataFound
        }
        var noService: APIService.Error{
            .ServiceNotFound
        }
        var errorDescription: String {
          switch self {
          case .ServiceNotFound: return "Service unreachable"
          case .BadURL: return "Invalid URL"
          case .NoDataFound: return "No data found"
          case .duplicate: return "Duplicate found"
          case .invalidResponse(let err): return err?.description ?? "invalid response"
          case .invalidJSON(let err): return err.localizedDescription
          }
        }
    }
    enum EndPoints{
        static let baseURL =  "https://" + Config.stringValue(forKey: "BASE_URL")
        case CarList
        var url:URL?{
            switch self{
            case .CarList:
                let url = EndPoints.baseURL + "carlist"
                guard let urlComponents = URLComponents(string: url) else{
                    return nil
                }
                guard let urlStr = urlComponents.url else{
                    return nil
                }
                return urlStr
            }
        }
    }
}
