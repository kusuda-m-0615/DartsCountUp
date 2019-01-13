//
//  ViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/14.
//  Copyright © 2018年 Masato Kusuda. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation


class ViewController: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{

    
    var audioPlayer: AVAudioPlayer!
    
    var multiple = 0
    var throwCountRound = 0
    var roundThreeThrow = ""
    var throwPoint = 0
    var roundNumber = 1
    
    var maxRound = 8
    var id = 0
    var throw1 = 0
    var throw1Multiple = 0
    var throw2 = 0
    var throw2Multiple = 0
    var throw3 = 0
    var throw3Multiple = 0
    var throwCountTotal :Int = 0

    var parameters = ["resultData" : "","pprData" : ""]
    @IBOutlet weak var scoreTotal: UITextField!
    @IBOutlet weak var scoreAverage: UITextField!
    @IBOutlet weak var scoreEstimate: UITextField!
    @IBOutlet weak var edit: UITextField!
    
    
    @IBOutlet weak var roundNo: UITableView!
    @IBOutlet weak var roundDataThrow1: UITableView!
    @IBOutlet weak var roundDataThrow2: UITableView!
    @IBOutlet weak var roundDataThrow3: UITableView!
    @IBOutlet weak var roundTotal: UITableView!
    
    
    var roundDataStr = "0"
    var insertId = 0
    var roundDataArray :[[Int?]] = [[1,nil,nil,nil,nil]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edit.becomeFirstResponder()
        edit.delegate = self
        scoreTotal.text = "0"
        roundNo.backgroundColor = UIColor.clear
        roundDataThrow1.backgroundColor = UIColor.clear
        roundDataThrow2.backgroundColor = UIColor.clear
        roundDataThrow3.backgroundColor = UIColor.clear
        roundTotal.backgroundColor = UIColor.clear
        }
    
    override func viewWillAppear(_ animated: Bool) {
        roundDataArray = [[1,nil,nil,nil,nil]]
        roundNumber = 1
        loadTable()
        self.edit.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roundNo.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // print(roundDataArray)
        var roundDataIndex = roundDataArray[indexPath.row]
        cell.textLabel!.text = ""
        switch(tableView.tag,indexPath.row){
        case (0,indexPath.row) :
            if let unrappedRoundData = roundDataIndex[tableView.tag] {
                cell.textLabel!.text = "R" + String(unrappedRoundData)
            }
        case(1 ... 4,indexPath.row) :
            if let unrappedRoundData = roundDataIndex[tableView.tag] {

                cell.textLabel!.text = String(unrappedRoundData)
            }
        default :cell.textLabel!.text = ""
        }
        cell.textLabel!.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    @IBAction func getPoint(_ sender: Any) {
        
        if (throwCountRound > 3){
            return;
        }
        
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

                    loadSetting(scoreArea: score.area,scorePoint: score.point)
                    
                    throwPoint = score.point * multiple
                    
                    let scoreTotalInt = Int(scoreTotal.text!)!
                    
                    throwCountRound += 1
                    throwCountTotal += 1
                    
                    if(throwCountRound < 3){
                        
                        calcPoint(throwPoint: throwPoint, scoreTotalCalc: scoreTotalInt)
                   //     playThrowSound(withPoint: throwPoint,throwCount: throwCountRound)
                        
                    }
                    
                    switch throwCountRound {
                    case 1:
                        throw1 = score.point
                        throw1Multiple = multiple
                    case 2:
                        throw2 = score.point
                        throw2Multiple = multiple
                    case 3:
                        throw3 = score.point
                        throw3Multiple = multiple
                    default:
                        break
                    }
                    
                }
            }
    }
    
    func calcPoint(throwPoint :Int,scoreTotalCalc :Int){
        
        let calcAvg = (scoreTotalCalc + throwPoint) / throwCountTotal * 3
        //let calcAvg = round(434 / 0.3) / 10
        scoreAverage.text = String(calcAvg)
        
        let calcEst = (scoreTotalCalc + throwPoint) / throwCountTotal  * (maxRound * 3 - throwCountTotal) + scoreTotalCalc + throwPoint
        scoreEstimate.text = String(calcEst)
        
        let calcTotal = String(scoreTotalCalc + throwPoint)
        scoreTotal.text = String(calcTotal)
        
        //ダーツを投げるごとに得点表示
        switch throwCountRound {
        case 1:
            roundDataArray[0][1] = throwPoint
            roundDataArray[0][4] = throwPoint
        case 2:
            roundDataArray[0][2] = throwPoint
            roundDataArray[0][4] = roundDataArray[0][4]! + throwPoint
        case 3:
            roundDataArray[0][3] = throwPoint
            roundDataArray[0][4] = roundDataArray[0][4]! + throwPoint
            if(UserDefaults.standard.bool(forKey: "Auto Change")){
                textFieldShouldReturn(edit)
            }
        default:
            break
        }
        loadTable()
        
    }
    
    func getZeroPoint(countRound :Int){
        var count = countRound
        print("GetZero" + String(count))
        switch count {
        case 0:
            throw1 = 0
            throw1Multiple = 1
            throw2 = 0
            throw2Multiple = 1
            throw3 = 0
            throw3Multiple = 1
        case 1:
            throw2 = 0
            throw2Multiple = 1
            throw3 = 0
            throw3Multiple = 1
        case 2:
            throw3 = 0
            throw3Multiple = 1
        default:
            break
        }
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if throwCountRound < 3 {
            getZeroPoint(countRound: throwCountRound)
        }
        
        let roundData = RoundData()

        //Changeボタンが押された時次のラウンドに移る
        let realm = try! Realm()
        if(realm.objects(RoundData.self).isEmpty){
            insertId = 1
        }else{
            insertId = realm.objects(RoundData.self).max(ofProperty: "id")!
        }
         try! realm.write {
            roundData.id = insertId + 1
            roundData.round_num = roundNumber
            roundData.throw1 = throw1
            roundData.throw1_multiple = throw1Multiple
            roundData.throw2 = throw2
            roundData.throw2_multiple = throw2Multiple
            roundData.throw3 = throw3
            roundData.throw3_multiple = throw3Multiple
            roundData.game_style = UserDefaults.standard.string(forKey: "Game Style") ?? "Count UP"
            roundData.bull_style = UserDefaults.standard.string(forKey: "Bull Style") ?? "50/50"
            realm.add(roundData)
        }
        
       // playSound(name: "gun-reload1")
        
        roundDataArray.insert([roundNumber + 1,nil,nil,nil,nil], at: 0)
        roundNumber += 1
        
        loadTable()
        print(roundDataArray)
        print(roundNumber)
        if(roundNumber > maxRound){
            completeRound()
        }
        id += 1
        throwCountRound = 0
        return true
    }
    
    func completeRound(){
        parameters.updateValue(scoreTotal.text!, forKey: "resultData")
        parameters.updateValue(scoreAverage.text!, forKey: "pprData")
        roundDataArray.removeAll()
        scoreTotal.text = "0"
        scoreAverage.text = "0"
        scoreEstimate.text = "0"
        
        self.performSegue(withIdentifier: "toResultViewController", sender: self.parameters)
        throwCountTotal = 0
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue,sender :Any?){
        if segue.identifier == "toResultViewController"{
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.parameters = sender as! [String : String]
        }
    }
    
    func loadSetting(scoreArea: String,scorePoint: Int){
        if(UserDefaults.standard.string(forKey: "Bull Style") == "50/50" && scoreArea == "outBull"){
            multiple = 2
        }
        
        if(UserDefaults.standard.string(forKey: "Selected Game") == "Eagle's Eye" ){
            switch scoreArea {
            case "outBull":
                multiple = 1
            case "inBull":
                multiple = 2
            case "outerSingle","innerSingle","double","triple":
                multiple = 0
            default:
                break
            }
        }
        if(UserDefaults.standard.string(forKey: "Selected Game") == "Big Bull" ){
            switch scoreArea {
            case "outBull","double":
                multiple = 2
                throwPoint = scorePoint * multiple
            case "triple","inBull":
                multiple = 3
                throwPoint = scorePoint * multiple
            case "outerSingle","innerSingle":
                throwPoint = 50
            default:
                break
            }
            
        }
        if(UserDefaults.standard.string(forKey: "Selected Game") == "No Bull" && (scoreArea == "outBull" || scoreArea == "innnerBull")){
                multiple = 0
        }
            
        
    }
    
    func loadTable(){
        roundNo.reloadData()
        roundDataThrow1.reloadData()
        roundDataThrow2.reloadData()
        roundDataThrow3.reloadData()
        roundTotal.reloadData()
    }
    
    func playThrowSound(withPoint : Int,throwCount : Int){
            switch withPoint {
            case 25:
                playSound(name: "line-girl1_line-girl1-o1")
            case 50:
                playSound(name: "line-girl1_line-girl1-oo1")
            case 51...60:
                playSound(name: "line-girl1_line-girl1-uwaa1")
            default :
                playSound(name: "shot")
            }
    }
    
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            
            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}




