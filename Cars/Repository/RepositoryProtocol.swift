//
//  ReepositoryProtocol.swift
//  Cars
//
//  Created by Linkon Sid on 17/12/22.
//

import SwiftUI

// Common error type for all repositories
protocol RepositoryError:Error{
    var noData:Self{get}
    var noService:Self{get}
}
//RepositoryProtocol is conformed by all classes that are part of the data repository and provide requested data
protocol RepositoryProtocol{
    associatedtype Request
    associatedtype Output
    associatedtype Context
    func getData(_ request:Request, _ context:Context)->Output
}
