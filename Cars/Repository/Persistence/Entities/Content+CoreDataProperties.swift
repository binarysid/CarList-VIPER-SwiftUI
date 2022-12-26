//
//  Content+CoreDataProperties.swift
//  Cars
//
//  Created by Linkon Sid on 21/12/22.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var desc: String?
    @NSManaged public var subject: String?
    @NSManaged public var type: String?
    @NSManaged public var cars: Car?

}

extension Content : Identifiable {

}
