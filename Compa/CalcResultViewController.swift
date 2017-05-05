//
//  CalcResultViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class CalcResultViewController: UIViewController {

    //Mark: Properties
    var myBirthday: NSDate!
    var friendBirthday: NSDate!
    
    @IBOutlet weak var myBirthdayLabel: UILabel!
    @IBOutlet weak var friendBirthdayLabel: UILabel!
    @IBOutlet weak var myEuroZodiacLabel: UILabel!
    @IBOutlet weak var friendEuroZodiacLabel: UILabel!
    @IBOutlet weak var euroZodiacCompLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myBirthdayLabel.text = MyUtil.stringDateFormat(myBirthday)
        friendBirthdayLabel.text = MyUtil.stringDateFormat(friendBirthday)
        
        myEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(myBirthday)
        friendEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(friendBirthday)
        euroZodiacCompLabel.text = String(Zodiac.getZodiacEuroPercent(myEuroZodiacLabel.text!, friendEuroZodiacLabel.text!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
