//
//  MyPageViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MyPageViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var myBirthday: UIDatePicker!
    @IBOutlet weak var friendBirthday: UIDatePicker!
    @IBOutlet weak var setToMyBirthday: UIButton!
    
    @IBOutlet weak var expressBanner: GADNativeExpressAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setToMyBirthday.isHidden = (MyProfile.sharedInstance.nsBirthday != nil) ? false : true
        
        expressBanner.adUnitID = "ca-app-pub-3940256099942544/4270592515"
        expressBanner.rootViewController = self
        
        let request = GADRequest()
        expressBanner.load(request)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func setMyToBirthdayAction(_ sender: Any) {
        myBirthday.date = MyProfile.sharedInstance.nsBirthday! as Date
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
