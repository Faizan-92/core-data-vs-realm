//
//  CoreDataHelper.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import Foundation
import CoreData

final class CoreDataHelper {
    var entityCount: Int64 = 0
    var context: NSManagedObjectContext
    let queue = DispatchQueue(label: "core_data_queue", qos: .userInitiated)

    init(context: NSManagedObjectContext) {
        self.context = context
        entityCount = Int64(getAllObjects()?.count ?? 0) 
    }

    func insertNewEntity( _ entity: TestEntity) {
        queue.sync { [self] in
            entityCount += 1
            entity.setValue(entityCount, forKey: "primaryKey")
            updateEntity(entity)
            do {
                try context.save()
            } catch let error as NSError {
                print("core data: could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func readEntity(primaryKey: Int64) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TestEntity")
        fetchRequest.predicate = NSPredicate(
            format: "primaryKey = %@", NSNumber(value: primaryKey)
        )
        do {
            let value = try context.fetch(fetchRequest)
            if (value.first as? TestEntity)?.primaryKey != primaryKey {
                print("core data: key not found")
            }
        } catch let error as NSError {
            print("core data: could not read \(error), \(error.userInfo)")
        }
    }

    func updateEntity(primaryKey: Int64) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TestEntity")
        fetchRequest.predicate = NSPredicate(
            format: "primaryKey = %@", NSNumber(value: primaryKey)
        )
        do {
            let value = try context.fetch(fetchRequest)
            if let entity = value.first as? TestEntity {
                if entity.primaryKey != primaryKey {
                    print("core data: key not found")
                } else {
                    updateEntity(entity)
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("core data: could not update. \(error), \(error.userInfo)")
                    }
                }
            }
            
        } catch let error as NSError {
            print("core data: could not read \(error), \(error.userInfo)")
        }
    }

    func deleteEntries() {
        let objects = getAllObjects()
        for entityObject in objects ?? [] {
            if let managedObject = entityObject as? NSManagedObject {
                context.delete(managedObject)
                try? context.save()
            }
        }
        entityCount = 0
    }

    private func getAllObjects() -> [NSFetchRequestResult]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
            entityName: "TestEntity"
        )
        return try? context.fetch(fetchRequest)
    }

    private func updateEntity(_ entity: TestEntity) {
        entity.column1 = UUID().uuidString
        entity.column2 = UUID().uuidString
        entity.column3 = UUID().uuidString
        entity.column4 = Double.random(in:0...10000000)
        entity.column5 = Double.random(in:0...10000000)
        entity.column6 = Double.random(in:0...10000000)
        entity.column7 = Bool.random()
        entity.column8 = Bool.random()
        entity.column9 = Bool.random()
        return
    }
}
