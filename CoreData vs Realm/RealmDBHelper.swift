//
//  RealmDBHelper.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import Foundation
import RealmSwift

final class RealmDBHelper {

    static func configureRealm() {

        let configuration = Realm.Configuration(
            fileURL: getFileUrl(),
            schemaVersion: 1,
            migrationBlock: { _, _ in
                
            }
        )

        Realm.Configuration.defaultConfiguration = configuration
    }

    static func getFileUrl() -> URL {
        return FileManager
            .default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
            .appendingPathComponent("db.realm")
    }

    static let appGroup: String = {
        if let value = Bundle.main.infoDictionary?["APP_GROUP"] as? String {
            return value
        }
        return "group.faizan.poc.coredata-vs-realm"
    }()

    let realm: Realm?
    var queue = DispatchQueue(label: "realm_queue", qos: .userInitiated)
    var entityCount: Int = 0

    init() {
        RealmDBHelper.configureRealm()
        self.realm = try? Realm()
        entityCount = getAllObjects()?.count ?? 0
        
    }

    func insertNewEntity( _ entity: TestRealmEntity) {
        queue.sync {
            entityCount += 1
            do {
                try realm?.write {
                    entity.primaryKey = entityCount
                    updateEntity(entity)
                    realm?.add(entity, update: .modified)
                }
            } catch let error as NSError {
                print("realm: could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func readEntity(primaryKey: Int) {
        let predicate = NSPredicate(
            format: "primaryKey = %d", NSNumber(value: primaryKey)
        )
        let results = realm?.objects(TestRealmEntity.self).filter(predicate)
        if results?.first?.primaryKey ?? 0 != primaryKey {
            print("realm: key not found")
        }
    }

    func updateEntity(primaryKey: Int) {
        let predicate = NSPredicate(
            format: "primaryKey = %d", NSNumber(value: primaryKey)
        )
        guard let entity = realm?.objects(TestRealmEntity.self).filter(predicate).first else {
            return
        }
        if entity.primaryKey != primaryKey {
            print("core data: key not found")
        } else {
            queue.sync {
                updateEntity(entity)
                do {
                    try realm?.write {
                        entity.primaryKey = entityCount
                        updateEntity(entity)
                        realm?.add(entity, update: .modified)
                    }
                } catch let error as NSError {
                    print("realm: could not write \(error), \(error.userInfo)")
                }
            }
        }
    }

    func deleteEntries() {
        if let objects = getAllObjects() {
            queue.sync {
                do {
                    try realm?.write {
                        realm?.delete(objects)
                    }
                } catch let error as NSError {
                    print("realm: could not delete \(error), \(error.userInfo)")
                }
            }
        }
        entityCount = 0
    }

    private func getAllObjects() -> Results<TestRealmEntity>? {
        return realm?.objects(TestRealmEntity.self)
    }

    private func updateEntity(_ entity: TestRealmEntity) {
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
