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
    
    @IBOutlet weak var myPhoto: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myBirthdayLabel: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendBirthdayLabel: UILabel!
    
    @IBOutlet weak var myEuroZodiacLabel: UILabel!
    @IBOutlet weak var myEuroZodiacIcon: UIImageView!
    @IBOutlet weak var friendEuroZodiacLabel: UILabel!
    @IBOutlet weak var friendEuroZodiacIcon: UIImageView!
    @IBOutlet weak var euroZodiacCompLabel: UILabel!
    
    @IBOutlet weak var myChinaZodiacLabel: UILabel!
    @IBOutlet weak var myChinaZodiacIcon: UIImageView!
    @IBOutlet weak var friendChinaZodiacLabel: UILabel!
    @IBOutlet weak var friendChinaZodiacIcon: UIImageView!
    @IBOutlet weak var chinaZodiacCompLabel: UILabel!
    
    @IBOutlet weak var averageCompLabel: UILabel!
    
    @IBOutlet weak var averageCompDescLabel: UILabel!
    @IBOutlet weak var chineseZodiacCompDescLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let myBirthdayStr: String
        let friendBirthdayStr: String
        
        // Check if from Friends List
        if friend != nil {
            // for test
            //myBirthday = MyUtil.nsDateFormat("1982-10-06")
            myBirthday = MyProfile.sharedInstance.nsBirthday
            
            friendBirthday = friend.nsBirthday
            
            if MyUtil.stringDateFormat(friendBirthday).range(of:"9999") != nil{
                myChinaZodiacLabel.isHidden = true
                friendChinaZodiacLabel.isHidden = true
                chinaZodiacCompLabel.isHidden = true
                averageCompLabel.isHidden = true
                
                averageCompDescLabel.isHidden = true
                chineseZodiacCompDescLabel.isHidden = true
                
                friendBirthdayStr = MyUtil.stringDateFormat(friendBirthday).replacingOccurrences(of: "9999-", with: "", options: .literal, range: nil)
            } else {
                friendBirthdayStr = MyUtil.stringDateFormat(friendBirthday)
            }
            
            myBirthdayStr = MyUtil.stringDateFormat(myBirthday)
            
            // Details from Facebook
            myName.text = MyProfile.sharedInstance.name
            friendName.text = friend.name
            
            myPhoto.downloadedFrom(link: MyProfile.sharedInstance.photoUrl!)
            //myPhoto.round()
            friendPhoto.downloadedFrom(link: friend.photoUrl!)
            //friendPhoto.round()
            
            //cell.friendImage.downloadedFrom(link: friend.photoUrl!)
            
        } else {
            myBirthdayStr = MyUtil.stringDateFormat(myBirthday)
            friendBirthdayStr = MyUtil.stringDateFormat(friendBirthday)
        }
        
        myBirthdayLabel.text = myBirthdayStr
        friendBirthdayLabel.text = friendBirthdayStr
        
        myEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(myBirthday)
        myEuroZodiacIcon.image = UIImage(named: myEuroZodiacLabel.text!)
        friendEuroZodiacLabel.text = Zodiac.getZodiacEuroSign(friendBirthday)
        friendEuroZodiacIcon.image = UIImage(named: friendEuroZodiacLabel.text!)
        let zodiacEuroComp = Zodiac.getZodiacEuroPercent(myEuroZodiacLabel.text!, friendEuroZodiacLabel.text!)
        euroZodiacCompLabel.text = " " + String(zodiacEuroComp) + "%"
        
        myChinaZodiacLabel.text = Zodiac.getZodiacChinaSign(myBirthday)
        myChinaZodiacIcon.image = UIImage(named: myChinaZodiacLabel.text!)
        friendChinaZodiacLabel.text = Zodiac.getZodiacChinaSign(friendBirthday)
        friendChinaZodiacIcon.image = UIImage(named: friendChinaZodiacLabel.text!)
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
