//
//  ResultViewController.swift
//  DartsCountUp
//
//  Created by Masato Kusuda on 2018/12/23.
//  Copyright © 2018 Masato Kusuda. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController ,UITextFieldDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var resultData: UITextField!
    @IBOutlet weak var pprData: UITextField!
    @IBOutlet weak var ppdData: UITextField!
    @IBOutlet weak var returnKey: UITextField!
    var parameters : [String : String] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        returnKey.delegate = self
        resultData.text = parameters["resultData"]
        pprData.text = parameters["pprData"]
        navigationController?.delegate = self
        self.returnKey.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return true
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
