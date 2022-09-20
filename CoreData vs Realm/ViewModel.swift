//
//  ViewModel.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import Foundation
import CoreData

protocol ViewModelDelegate: AnyObject {
    func createActionCompleted(timeTaken: Int64)
    func readActionCompleted(timeTaken: Int64)
    func updateActionCompleted(timeTaken: Int64)
    func deleteActionCompleted(timeTaken: Int64)
}

final class ViewModel {
    var currentDB: DatabaseType = .coreData
    var actionStartTimeStamp: Int64 = Date().millisSince1970
    var coreDataHelper: CoreDataHelper
    var realmDBHelper: RealmDBHelper
    var viewContext: NSManagedObjectContext
    weak var delegate: ViewModelDelegate?

    init(delegate: ViewModelDelegate, viewContext: NSManagedObjectContext) {
        self.delegate = delegate
        self.viewContext = viewContext
        coreDataHelper = CoreDataHelper(context: viewContext)
        realmDBHelper = RealmDBHelper()
    }

    func updateSelectedDB(_ value: DatabaseType) {
        self.currentDB = value
    }

    func createEntries(_ numberOfItems: Int) {
        actionStartTimeStamp = Date().millisSince1970
        for _ in 0..<numberOfItems {
            if self.currentDB == .coreData {
                let entityDescription = NSEntityDescription.entity(
                    forEntityName: "TestEntity",
                    in: viewContext
                )!
                let entity = TestEntity(entity: entityDescription, insertInto: viewContext)
                coreDataHelper.insertNewEntity(entity)
            } else {
                realmDBHelper.insertNewEntity(TestRealmEntity())
            }
        }
        delegate?.createActionCompleted(
            timeTaken: Date().millisSince1970 - actionStartTimeStamp
        )
    }

    func readEntries(_ numberOfItems: Int) {
        actionStartTimeStamp = Date().millisSince1970
        for _ in 0..<numberOfItems {
            if currentDB == .coreData {
                coreDataHelper.readEntity(
                    primaryKey: Int64.random(in: 1...coreDataHelper.entityCount)
                )
            } else {
                realmDBHelper.readEntity(
                    primaryKey: Int.random(in: 1...realmDBHelper.entityCount)
                )
            }
        }
        delegate?.readActionCompleted(
            timeTaken: Date().millisSince1970 - actionStartTimeStamp
        )
    }

    func updateEntries(_ numberOfItems: Int) {
        actionStartTimeStamp = Date().millisSince1970
        for _ in 0..<numberOfItems {
            if currentDB == .coreData {
                coreDataHelper.updateEntity(
                    primaryKey: Int64.random(in: 1...coreDataHelper.entityCount)
                )
            } else {
                realmDBHelper.updateEntity(
                    primaryKey: Int.random(in: 1...realmDBHelper.entityCount)
                )
            }
        }
        delegate?.updateActionCompleted(
            timeTaken: Date().millisSince1970 - actionStartTimeStamp
        )
    }

    func deleteEntries() {
        actionStartTimeStamp = Date().millisSince1970
        if currentDB == .coreData {
            coreDataHelper.deleteEntries()
        } else {
            realmDBHelper.deleteEntries()
        }
        delegate?.deleteActionCompleted(
            timeTaken: Date().millisSince1970 - actionStartTimeStamp
        )
    }
}
