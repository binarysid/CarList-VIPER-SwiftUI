//
//  Car+CoreDataProperties.swift
//  Cars
//
//  Created by Linkon Sid on 21/12/22.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var ingress: String
    @NSManaged public var subject: String?
    @NSManaged public var tags: String?
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var type: String?
    @NSManaged public var content: Content?

}

extension Car : Identifiable {

}
