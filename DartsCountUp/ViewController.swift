//
//  ViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/14.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import UIKit
import RealmSwift



class ViewController: UIViewController ,UITextFieldDelegate,UITableViewDelegate{
    
    var multiple = 0
    var throwCount = 0
    var roundThreeThrow = ""
    var throwPoint = 0
    var roundNumber = 1
    
    var maxRound = 8
    var roundTotalScore = 0
    var roundTable: UITableView!
    var id = 0
    var throw1 = 0
    var throw2 = 0
    var throw3 = 0

    @IBOutlet weak var scoreTotal: UITextField!
    @IBOutlet weak var edit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edit.becomeFirstResponder()
        edit.delegate = self
        scoreTotal.text = "0"

        
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getPoint(_ sender: Any) {
        let realm = try! Realm()
        let pointList = realm.objects(Point.self)
            pointList.forEach{ score in
                if(score.id == edit.text!.suffix(1)){
                    
                    switch score.area {
                    case "innerSingle","outerSingle","outBull":
                        multiple = 1
                    case "double","inBull":
                        multiple = 2
                    case "triple":
                        multiple = 3
                    default:
                        break
                    }
                    
                    throwPoint = score.point * multiple
                    
                    switch throwCount {
                    case 0:
                        throw1 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    case 1:
                        throw2 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    case 2:
                        throw3 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    default:
                        break
                    }
                        roundTotalScore = roundTotalScore + throwPoint
                        throwCount = throwCount + 1
                    
                }
            }
    }


    
    @objc func inputFromHistory(sender: UITapGestureRecognizer) {
        if let cell = sender.view as? UITableViewCell {
            edit.text = cell.textLabel?.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(roundNumber > maxRound){
            roundNumber = 1
        }
        switch throwCount {
        case 0:
            throw1 = 0
            throw2 = 0
            throw3 = 0
        case 1:
            throw2 = 0
            throw3 = 0
        case 2:
            throw3 = 0
        default:
            break
        }
        let roundData = RoundData()

        //Changeボタンが押された時次のラウンドに移る
        let realm = try! Realm()
        try! realm.write {
            roundData.id = id
            roundData.round_num = roundNumber
            roundData.throw1 = throw1
            roundData.throw2 = throw2
            roundData.throw3 = throw3
            realm.add(roundData)
        }
        roundNumber += 1
        id += 1
        if(roundNumber == maxRound){
            scoreTotal.text = "0"
        }
        throwCount = 0
        return true
    }
    
}




