//
//  TestRealmEntity.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import Foundation
import RealmSwift

class TestRealmEntity: Object {
    @objc dynamic var primaryKey: Int = 0
    @objc dynamic var column1: String?
    @objc dynamic var column2: String?
    @objc dynamic var column3: String?
    @objc dynamic var column4: Double = 0
    @objc dynamic var column5: Double = 0
    @objc dynamic var column6: Double = 0
    @objc dynamic var column7: Bool = false
    @objc dynamic var column8: Bool = false
    @objc dynamic var column9: Bool = false

    convenience init(
        primaryKey: Int,
        column1: String,
        column2: String,
        column3: String,
        column4: Double,
        column5: Double,
        column6: Double,
        column7: Bool,
        column8: Bool,
        column9: Bool
    ) {
        self.init()
        self.primaryKey = primaryKey
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
        self.column6 = column6
        self.column7 = column7
        self.column8 = column8
        self.column9 = column9
    }

    override static func primaryKey() -> String? {
       return "primaryKey"
   }

}
