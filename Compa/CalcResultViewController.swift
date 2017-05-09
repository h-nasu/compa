//
//  CalcResultViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class CalcResultViewController: UIViewController {

    //MARK: Properties
    var myBirthday: NSDate!
    var friendBirthday: NSDate!
    var friend: Friend!
    
    @IBOutlet weak var myBirthdayLabel: UILabel!
    @IBOutlet weak var friendBirthdayLabel: UILabel!
    @IBOutlet weak var myEuroZodiacLabel: UILabel!
    @IBOutlet weak var friendEuroZodiacLabel: UILabel!
    @IBOutlet weak var euroZodiacCompLabel: UILabel!
    @IBOutlet weak var myChinaZodiacLabel: UILabel!
    @IBOutlet weak var friendChinaZodiacLabel: UILabel!
    @IBOutlet weak var chinaZodiacCompLabel: UILabel!
    @IBOutlet weak var averageCompLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Check if from Friends List
        if friend != nil {
            // for test
            myBirthday = MyUtil.nsDateFormat("1982-10-06")
            friendBirthday = friend.nsBirthday
        }
        
        myBirthdayLabel.text = MyUtil.stringDateFormat(myBirthday)
        friendBirthdayLabel.text = MyUtil.stringDateFormat(friendBirthday)
        
        myEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(myBirthday)
        friendEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(friendBirthday)
        let zodiacEuroComp = Zodiac.getZodiacEuroPercent(myEuroZodiacLabel.text!, friendEuroZodiacLabel.text!)
        euroZodiacCompLabel.text = " " + String(zodiacEuroComp) + "%"
        
        myChinaZodiacLabel.text = Zodiac.getZodiacChinaSign(myBirthday)
        friendChinaZodiacLabel.text = Zodiac.getZodiacChinaSign(friendBirthday)
        let zodiacChinaComp = Zodiac.getZodiacChinaPercent(myChinaZodiacLabel.text!, friendChinaZodiacLabel.text!)
        chinaZodiacCompLabel.text = " " + String(zodiacChinaComp) + "%"
        
        averageCompLabel.text =  " " + String((zodiacEuroComp + zodiacChinaComp) / 2) + "%"
        
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