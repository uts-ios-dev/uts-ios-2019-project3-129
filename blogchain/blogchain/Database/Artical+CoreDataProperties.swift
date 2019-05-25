//
//  Artical+CoreDataProperties.swift
//  
//
//  Created by 李宇沛 on 23/5/19.
//
//

import Foundation
import CoreData


extension Artical {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artical> {
        return NSFetchRequest<Artical>(entityName: "Artical")
    }

    @NSManaged public var category: Int16
    @NSManaged public var content: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var addressKey: String?
    @NSManaged public var modified: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var dirty: Bool

}
