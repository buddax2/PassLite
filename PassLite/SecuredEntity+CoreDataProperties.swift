//
//  SecuredEntity+CoreDataProperties.swift
//  PassLite
//
//  Created by Oleksandr Yakubchyk on 18.10.2020.
//
//

import Foundation
import CoreData

@objc(SecuredEntity)
public class SecuredEntity: NSManagedObject, Identifiable {
    @NSManaged public var name: String
    @NSManaged public var username: String
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var note: String?
}

extension SecuredEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecuredEntity> {
        return NSFetchRequest<SecuredEntity>(entityName: "SecuredEntity")
    }
}

extension SecuredEntity {
    static func getAllItems() -> NSFetchRequest<SecuredEntity> {
        let request: NSFetchRequest<SecuredEntity> = SecuredEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    static func getItem(id: String) -> NSFetchRequest<SecuredEntity> {
        let request: NSFetchRequest<SecuredEntity> = SecuredEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "id = %@", id)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        
        return request
    }
}
