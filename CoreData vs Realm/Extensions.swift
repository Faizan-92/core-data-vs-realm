//
//  Extensions.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import Foundation

extension Date {
    var millisSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
