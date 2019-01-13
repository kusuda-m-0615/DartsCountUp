//
//  DataViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/12/02.
//  Copyright © 2018 Masato Kusuda. All rights reserved.
//

import UIKit
import RealmSwift

class DataViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{


    @IBOutlet weak var columnHeader1: UITableView!
    @IBOutlet weak var single1: UITableView!
    @IBOutlet weak var double1: UITableView!
    @IBOutlet weak var triple1: UITableView!

    @IBOutlet weak var columnHeader2: UITableView!
    @IBOutlet weak var single2: UITableView!
    @IBOutlet weak var double2: UITableView!
    @IBOutlet weak var triple2: UITableView!
    
    let columnHeader1Box : [String] = ["","0","1","2","3","4","5","6","7","8","9","10"]
    let columnHeader2Box : [String] = ["","11","12","13","14","15","16","17","18","19","20","Bull"]
    
    var single1Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var double1Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var triple1Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var single2Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var double2Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var triple2Box :[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath )-> UITableViewCell {
        print(indexPath.row)
        let cell = columnHeader1.dequeueReusableCell(withIdentifier: "columnHeader1Cell",for:indexPath)
        switch(tableView.tag,indexPath.row){
        case (0,_) :
            cell.textLabel!.text = columnHeader1Box[indexPath.row]
        case (1,0) :
            cell.textLabel!.text = "S"
        case (2,0) :
            cell.textLabel!.text = "D"
        case (3,0) :
            cell.textLabel!.text = "T"
        case (4,_) :
            cell.textLabel!.text = columnHeader2Box[indexPath.row]
        case (5,0) :
            cell.textLabel!.text = "S"
        case (6,0) :
            cell.textLabel!.text = "D"
        case (7,0) :
            cell.textLabel!.text = "T"
        case (1,1...11) :
            cell.textLabel!.text = String(single1Box[indexPath.row])
        case (2,1...11) :
            cell.textLabel!.text = String(double1Box[indexPath.row])
        case (3,1...11):
            cell.textLabel!.text = String(triple1Box[indexPath.row])
        case (4,1...11) :
            cell.textLabel!.text = columnHeader2Box[indexPath.row]
        case (5,1...11) :
            cell.textLabel!.text = String(single2Box[indexPath.row])
        case (6,1...11) :
            cell.textLabel!.text = String(double2Box[indexPath.row])
        case (7,1...11) :
            cell.textLabel!.text = String(triple2Box[indexPath.row])
        default :
            break
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let dataList = realm.objects(RoundData.self)
        
        dataList.forEach() { point in

            switch (point.throw1,point.throw1_multiple){
            case (0...10 , 1):
                single1Box[point.throw1 + 1] += 1
            case (0...10 , 2):
                double1Box[point.throw1 + 1] += 1
            case (0...10 , 3):
                triple1Box[point.throw1 + 1] += 1
            case (11...20 , 1):
                single2Box[point.throw1 - 10] += 1
            case (11...20,  2):
                double2Box[point.throw1 - 10] += 1
            case (11...20 , 3):
                triple2Box[point.throw1 - 10] += 1
            case (25 , 1):
                single2Box[11] += 1
            case (25 , 2):
                double2Box[11] += 1
            default:
                break
            }
            switch (point.throw2,point.throw2_multiple){
                
            case (0...10 , 1):
                single1Box[point.throw2 + 1] += 1
            case (0...10 , 2):
                double1Box[point.throw2 + 1] += 1
            case (0...10 , 3):
                triple1Box[point.throw2 + 1] += 1
            case (11...20 , 1):
                single2Box[point.throw2 - 10] += 1
            case (11...20,  2):
                double2Box[point.throw2 - 10] += 1
            case (11...20 , 3):
                triple2Box[point.throw2 - 10] += 1
            case (25 , 1):
                single2Box[11] += 1
            case (25 , 2):
                double2Box[11] += 1
            default:
                break
            }
            switch (point.throw3,point.throw3_multiple){
                
            case (0...10 , 1):
                single1Box[point.throw3 + 1] += 1
            case (0...10 , 2):
                double1Box[point.throw3 + 1] += 1
            case (0...10 , 3):
                triple1Box[point.throw3 + 1] += 1
            case (11...20 , 1):
                single2Box[point.throw3 - 10] += 1
            case (11...20 ,  2):
                double2Box[point.throw3 - 10] += 1
            case (11...20 , 3):
                triple2Box[point.throw3 - 10] += 1
            case (25 , 1):
                single2Box[11] += 1
            case (25 , 2):
                double2Box[11] += 1
            default:
                break
                }
            single1.reloadData()
            double1.reloadData()
            triple1.reloadData()

            
        }
        
        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
