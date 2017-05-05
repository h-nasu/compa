//
//  MyPageViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    //Mark: Properties
    @IBOutlet weak var myBirthday: UIDatePicker!
    @IBOutlet weak var friendBirthday: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { super.prepare(for: segue, sender: sender)        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "CalcMyPage":
            guard let CalcResultVC = segue.destination as? CalcResultViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            // pass to vc properties
            CalcResultVC.myBirthday = myBirthday.date as NSDate
            CalcResultVC.friendBirthday = friendBirthday.date as NSDate
            
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
 

}
