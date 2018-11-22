//
//  ReamSwift.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/19.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import Foundation
import RealmSwift



class RoundData: Object {
    @objc dynamic var id : Int = 0;
    @objc dynamic var round_num : Int = 0;
    @objc dynamic var throw1 : Int = 0;
    @objc dynamic var throw2 : Int = 0;
    @objc dynamic var throw3 : Int = 0;
    @objc dynamic var date = Date();
}

class DBBase: Object {
    @objc dynamic var id = "";
    @objc dynamic var point = 0;
    @objc dynamic var area = "";
    
    override static func primaryKey() -> String?{
        return "id"
    }
    override static func indexedProperties() -> [String]{
        return ["id"]
    }
}


