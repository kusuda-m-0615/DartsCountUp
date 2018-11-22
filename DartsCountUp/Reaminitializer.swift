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
      //  var config = Realm.Configuration.defaultConfiguration
       // config.deleteRealmIfMigrationNeeded = true
       // let realm = try! Realm(configuration: config)
        insertSeedData(PointSeed())
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
