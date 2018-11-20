//
//  RealmSeed.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/19.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import Foundation

protocol RealmSeed {
    associatedtype SeedType: DBBase
    static var values: [[Any]] { get }
    static func items() -> [SeedType]
}

extension RealmSeed {
    static func items() -> [SeedType]{
        return values.map { val in
            let t = SeedType()
            t.id = val[0] as! String
            t.point = val[1] as! Int
            t.area = val[2] as! String
            return t
        }
    }
}


