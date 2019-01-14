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
    var throwPoint = 0
    var roundNumber = 1
    
    var maxRound = 8
    var id = 0
    var throwCountTotal = 0

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
    //[RoundNo,1投目,2投目,3投目,合計点,1投目素点,1投目エリア,2投目素点,2投目エリア,3投目素点,3投目エリア]
    var roundDataArray :[[Int?]] = [[1,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]]
    
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
        roundDataArray = [[1,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]]
        roundNumber = 1
        loadTable()
        self.edit.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("カウント")
        //print(roundDataArray.count)
        return roundDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roundNo.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       //print(roundDataArray)
        //print(indexPath.row)
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
        
        guard (throwCountRound < 3) else {
            return
        }
        let realm = try! Realm()
        let pointList = realm.objects(Point.self)
            pointList.forEach{ score in
                if(score.id == edit.text!.suffix(1)){
                    
                    let multipleInt = loadSetting(scorePoint: score.point,scoreArea: score.area)

                    throwPoint = score.point * multipleInt
                    
                    calcPoint(originalPoint: score.point,originalMultiple: multiple,throwPoint: throwPoint)
                    
                   //     playThrowSound(withPoint: throwPoint,throwCount: throwCountRound)
                }
            }
    }
    
    func calcPoint(originalPoint :Int,originalMultiple :Int,throwPoint :Int){
        
        insertArray(originalPoint: originalPoint,originalMultiple :originalMultiple,throwPoint :throwPoint)
        
        let scoreTotalInt = Int(scoreTotal.text!)!
        
        let calcTotal = String(scoreTotalInt + throwPoint)
        scoreTotal.text = String(calcTotal)
        
        let calcAvg = (scoreTotalInt + throwPoint) / throwCountTotal * 3
        scoreAverage.text = String(calcAvg)
        
        let calcEst = (scoreTotalInt + throwPoint) / throwCountTotal  * (maxRound * 3 - throwCountTotal) + scoreTotalInt + throwPoint
        scoreEstimate.text = String(calcEst)
        
        
    }
    
    func getZeroPoint(countRound :Int){
        var i :Int = countRound
        while (i < 3){
            throwPoint = 0
            calcPoint(originalPoint: 0,originalMultiple: 0,throwPoint: 0)
            i += 1
        }

    }
    
    func insertArray(originalPoint :Int,originalMultiple :Int,throwPoint :Int){
        
        throwCountRound += 1
        throwCountTotal += 1
        //ダーツを投げるごとに得点表示
        switch throwCountRound {
        case 1:
            roundDataArray[0][1]  = throwPoint
            roundDataArray[0][4]  = throwPoint
            roundDataArray[0][5]  = originalPoint
            roundDataArray[0][6]  = originalMultiple
        case 2:
            roundDataArray[0][2]  = throwPoint
            roundDataArray[0][4]  = roundDataArray[0][4]! + throwPoint
            roundDataArray[0][7]  = originalPoint
            roundDataArray[0][8]  = originalMultiple
        case 3:
            roundDataArray[0][3]  = throwPoint
            roundDataArray[0][4]  = roundDataArray[0][4]! + throwPoint
            roundDataArray[0][9]  = originalPoint
            roundDataArray[0][10] = originalMultiple

        default:
            break
        }
        loadTable()
    }
    
    func insertDB(){
        
    }
    
    func completeRound(){
        guard (throwCountRound > 2) else {
            getZeroPoint(countRound: throwCountRound)
            return
        }
        print("completeRound")
        let roundData = RoundData()
        
        let realm = try! Realm()
        if(realm.objects(RoundData.self).isEmpty){
            insertId = 1
        }else{
            insertId = realm.objects(RoundData.self).max(ofProperty: "id")!
        }
        try! realm.write {
            roundData.id              = insertId + 1
            roundData.round_num       = roundDataArray[0][1]!
            roundData.throw1          = roundDataArray[0][5]!
            roundData.throw1_multiple = roundDataArray[0][6]!
            roundData.throw2          = roundDataArray[0][7]!
            roundData.throw2_multiple = roundDataArray[0][8]!
            roundData.throw3          = roundDataArray[0][9]!
            roundData.throw3_multiple = roundDataArray[0][10]!
            roundData.game_style = UserDefaults.standard.string(forKey: "Game Style") ?? "Count UP"
            roundData.bull_style = UserDefaults.standard.string(forKey: "Bull Style") ?? "50/50"
            realm.add(roundData)
        }
        
        // playSound(name: "gun-reload1")
        roundNumber += 1
        roundDataArray.insert([roundNumber,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil], at: 0)
        
        
        if(roundNumber > maxRound){
            completeGame()
        }else{
            loadTable()
        }
        throwCountRound = 0
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completeRound()
        return true
    }
    
    func completeGame(){
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
    
    func loadSetting(scorePoint: Int,scoreArea: String) -> Int{
        
        switch scoreArea {
        case "innerSingle","outerSingle","outBull":
            multiple = 1
        case "double","inBull":
            multiple = 2
        case "triple":
            multiple = 3
        default:
            break
        }
        
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
            
        return multiple
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




