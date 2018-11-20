//
//  ViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/14.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()
let pointList = realm.objects(Point.self)
let roundList = realm.objects(RoundData.self)
let roundData = RoundData()

class ViewController: UIViewController ,UITextFieldDelegate,UITableViewDelegate{
    
    let userDefaults = UserDefaults.standard
    var multiple = 0

    var throwCount = 0
    var roundThreeThrow = ""
    var throwPoint = 0
    var maxRound = 8
    var roundTotalScore = 0
    var roundTable: UITableView!
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var textFieldHeight: CGFloat = 40

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
    
    @IBAction func deleteTable(){
        userDefaults.removeObject(forKey: "inputHistory")
        
    }
    @IBAction func getPoint(_ sender: Any) {

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
                        roundData.throw1 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    case 1:
                        roundData.throw2 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    case 2:
                        roundData.throw3 = throwPoint
                        scoreTotal.text = String(Int(scoreTotal.text!)! + throwPoint)
                    default:
                        break
                    }
                        roundTotalScore = roundTotalScore + throwPoint
                    
                        if(throwPoint < 10){
                            roundThreeThrow = roundThreeThrow + " 0" + String(throwPoint)
                        }else{
                            roundThreeThrow = roundThreeThrow + " " + String(throwPoint)
                         }
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
        switch throwCount {
        case 0:
            roundData.throw1 = 0
            roundData.throw2 = 0
            roundData.throw3 = 0
        case 1:
            roundData.throw2 = 0
            roundData.throw3 = 0
        case 2:
            roundData.throw3 = 0
        default:
            break
        }
        roundThreeThrow = roundThreeThrow + " / " + String(roundTotalScore)
        //Changeボタンが押された時次のラウンドに移る
        addRound(roundTotal: roundThreeThrow)
        [roundTable .reloadData()]
        textField.text = ""
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let topMargin = statusBarHeight + textFieldHeight
        
        roundTable = UITableView(frame: CGRect(x: 10, y: 10, width: 200, height: self.view.frame.height - topMargin))
        roundTable.delegate = self
        roundTable.backgroundColor = UIColor(white: 0, alpha: 0.5)
        roundTable.allowsSelection = false
        self.view.addSubview(roundTable)
        
        return true
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return getInputHistory().count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style:  .default, reuseIdentifier: "Cell")
//        cell.textLabel?.text = getInputHistory()[indexPath.row]
////        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.inputFromHistory(sender:))))
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // テーブルセルの高さを設定
//        return textFieldHeight
//    }

    
}




