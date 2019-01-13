//
//  SettingsViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/11/28.
//  Copyright © 2018 Masato Kusuda. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import ImageRow

class SetteingViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< SegmentedRow<String>(){ row in
                row.options = ["50/50","25/50","No Bull"]
                row.title = "Bull Style"
                row.value = "50/50"
                row.value =  UserDefaults.standard.string(forKey: "Bull Style")
                }.onChange{ row in
           UserDefaults.standard.set(row.value,forKey: "Bull Style")
            }
            <<< SegmentedRow<String>(){ row in
                row.options = ["Count Up","Big Bull","Eagle's Eye"]
                row.title = "Selected Game"
                row.value = "Count Up"
                row.value =  UserDefaults.standard.string(forKey: "Game Style")
                }.onChange{ row in
                    UserDefaults.standard.set(row.value,forKey: "Game Style")
            }
            <<< SwitchRow(){ row in
                row.title = "Auto Change"
                row.value = false
                row.value =  UserDefaults.standard.bool(forKey: "Auto Change")
                }.onChange{ row in
                    UserDefaults.standard.set(row.value,forKey: "Auto Change")

        }
                
     
    }
}
