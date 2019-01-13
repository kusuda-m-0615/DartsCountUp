//
//  Reaminitialiser.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/20.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import Foundation
import RealmSwift



struct RealmaInitializer {
    
  static func setUp(){
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        insertSeedData(PointSeed())
        
    }
    
    private static func delete <T: RealmSeed>(_ seed: T) where T.SeedType: DBBase {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(T.SeedType.self))
        }
    }

    private static func insertSeedData<T: RealmSeed>(_ seed: T) where T.SeedType: DBBase {
        let realm = try! Realm()
        try! realm.write {
            T.items().forEach { val in
                realm.add(val,update :true)
            }
        }
    }
}
