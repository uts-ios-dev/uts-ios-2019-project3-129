//
//  Artical+CoreDataProperties.swift
//  
//
//  Created by AnLuoRidge on 30/5/19.
//
//

import Foundation
import CoreData


extension Artical {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artical> {
        return NSFetchRequest<Artical>(entityName: "Artical")
    }

    @NSManaged public var addressKey: String?
    @NSManaged public var category: Int16
    @NSManaged public var content: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var dirty: Bool
    @NSManaged public var modified: NSDate?
    @NSManaged public var title: String?

}
