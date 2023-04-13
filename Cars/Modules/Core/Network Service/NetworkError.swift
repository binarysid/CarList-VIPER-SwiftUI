//
//  NetworkError.swift
//  GithubUserSearch
//
//  Created by Linkon Sid on 23/3/23.
//

import Foundation

enum NetworkError: Error {
    case serviceNotFound
    case badURL
    case noDataFound
    case duplicateResponse
    case invalidResponse
    case invalidJson
    case noConnection
    case taskRunning
}

// extension NetworkError: LocalizedError {
//    var errorDescription: String? {
//        switch self {
//        case .serviceNotFound: return TextConstant.NetworkError.serviceNotFound
//        case .badURL: return TextConstant.NetworkError.badURL
//        case .noDataFound: return TextConstant.NetworkError.noDataFound
//        case .duplicateResponse: return TextConstant.NetworkError.duplicate
//        case .invalidResponse: return TextConstant.NetworkError.invalidResponse
//        case .noConnection: return TextConstant.NetworkError.noConnection
//        case .invalidJson: return TextConstant.NetworkError.invalidJson
//        case .taskRunning: return TextConstant.NetworkError.taskRunning
//        }
//    }
// }
