//
//  PointSeed.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/20.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import Foundation

struct PointSeed: RealmSeed {
    typealias SeedType = Point
    static var values:[[Any]]{
        return PointFomatter.data
    }
}

struct  PointFomatter {
    static let data: [[Any]] = [
        [":",25,"inBull"],
        ["$",25,"outBull"],
        ["I",1,"double"],
        ["2",2,"double"],
        ["X",3,"double"],
        ["M",4,"double"],
        ["6",5,"double"],
        ["k",6,"double"],
        ["l",7,"double"],
        ["F",8,"double"],
        ["e",9,"double"],
        ["T",10,"double"],
        [">",11,"double"],
        ["i",12,"double"],
        ["?",13,"double"],
        [")",14,"double"],
        ["W",15,"double"],
        ["M",16,"double"],
        ["Q",17,"double"],
        [",",18,"double"],
        ["R",19,"double"],
        ["(",20,"double"],
        ["'",1,"triple"],
        ["G",2,"triple"],
        ["#",3,"triple"],
        ["S",4,"triple"],
        ["_",5,"triple"],
        ["3",6,"triple"],
        ["C",7,"triple"],
        ["U",8,"triple"],
        ["=",9,"triple"],
        [";",10,"triple"],
        ["A",11,"triple"],
        ["j",12,"triple"],
        ["+",13,"triple"],
        ["t",14,"triple"],
        ["!",15,"triple"],
        ["1",16,"triple"],
        ["E",17,"triple"],
        ["8",18,"triple"],
        ["d",19,"triple"],
        ["f",20,"triple"],
        ["c",1,"innerSingle"],
        ["5",2,"innerSingle"],
        ["V",3,"innerSingle"],
        ["=",4,"innerSingle"],
        ["a",5,"innerSingle"],
        ["7",6,"innerSingle"],
        ["/",7,"innerSingle"],
        ["\"",8,"innerSingle"],
        ["&",9,"innerSingle"],
        ["b",10,"innerSingle"],
        ["J",11,"innerSingle"],
        ["%",12,"innerSingle"],
        ["<",13,"innerSingle"],
        [".",14,"innerSingle"],
        ["Y",15,"innerSingle"],
        ["O",16,"innerSingle"],
        ["L",17,"innerSingle"],
        ["r",18,"innerSingle"],
        ["9",19,"innerSingle"],
        ["N",20,"innerSingle"],
        ["n",1,"outerSingle"],
        ["D",2,"outerSingle"],
        ["P",3,"outerSingle"],
        ["h",4,"outerSingle"],
        ["-",5,"outerSingle"],
        ["Z",6,"outerSingle"],
        ["4",7,"outerSingle"],
        ["0",8,"outerSingle"],
        ["K",9,"outerSingle"],
        ["s",10,"outerSingle"],
        ["*",11,"outerSingle"],
        ["\\",12,"outerSingle"],
        ["@",13,"outerSingle"],
        ["g",14,"outerSingle"],
        ["q",15,"outerSingle"],
        ["H",16,"outerSingle"],
        ["o",17,"outerSingle"],
        ["^",18,"outerSingle"],
        ["B",19,"outerSingle"],
        ["p",20,"outerSingle"]
    ]
}
