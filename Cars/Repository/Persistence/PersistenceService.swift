//
//  PersistenceService.swift
//  Cars
//
//  Created by Linkon Sid on 25/12/22.
//

import CoreData

struct PersistenceService{
    enum Context{
        case Main(NSManagedObjectContext)
        case Background(NSManagedObjectContext)
        typealias type = NSManagedObjectContext
        
        var value:NSManagedObjectContext{
            switch self {
            case .Main(let context):
                return context
            case .Background(let context):
                return context
            }
        }
    }
    indirect enum Error: RepositoryError {
        case NoDataFound
        case InvalidManagedObjectType
        case ServiceNotAvailable
        case FailedToSave
        case FailedToDelete
        case DataHandlingError
        
        var noData: PersistenceService.Error{
            .NoDataFound
        }
        var noService: PersistenceService.Error{
            .ServiceNotAvailable
        }
        var errorDescription: String {
            switch self {
            case .ServiceNotAvailable: return "Service unreachable"
            case .NoDataFound: return "No data found"
            case .InvalidManagedObjectType:  return "Something went wrong"
            case .FailedToSave:
                return "Failed to save data"
            case .FailedToDelete:
                return "Item deletion failed"
            case .DataHandlingError:
                return "Error while handling data"
            }
        }
    }
    
    enum Entity{
        enum CarList{
            static var FetchRequest:NSFetchRequest<Car>{
                Car.fetchRequest()
            }
            typealias RequestParam = (NSFetchRequest<Car>,NSManagedObjectContext)
        }
//        enum RequestParam{
//
//        }
//        enum Request{
//            static var CarList:NSFetchRequest<Car>{
//                Car.fetchRequest()
//            }
//        }
//        enum Param{
//            typealias CarList = (type: NSFetchRequest<Car>, context: NSManagedObjectContext)
//        }
    }
}

enum CDEn{
    case Main(NSManagedObjectContext)
    case Bg(NSManagedObjectContext)
}

var cd = CDEn.Main(CoreDataStack.mainContext)
