//
//  CalcResultViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import GoogleMobileAds

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
    
    @IBOutlet weak var bannerView: GADBannerView!
    
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
            
        } else {
            myBirthdayStr = MyUtil.stringDateFormat(myBirthday)
            friendBirthdayStr = MyUtil.stringDateFormat(friendBirthday)
        }
        
        myBirthdayLabel.text = myBirthdayStr
        friendBirthdayLabel.text = friendBirthdayStr
        
        let myZodiacName = Zodiac.getZodiacEuroSign(myBirthday)
        myEuroZodiacLabel.text = NSLocalizedString(myZodiacName, comment: "Zodiac")
        myEuroZodiacIcon.image = UIImage(named: myZodiacName)
        let friendZodiacName = Zodiac.getZodiacEuroSign(friendBirthday)
        friendEuroZodiacLabel.text = NSLocalizedString(friendZodiacName, comment: "Zodiac")
        friendEuroZodiacIcon.image = UIImage(named: friendZodiacName)
        let zodiacEuroComp = Zodiac.getZodiacEuroPercent(myZodiacName, friendZodiacName)
        euroZodiacCompLabel.text = " " + String(zodiacEuroComp) + "%"
        
        let myChinaZodiacName = Zodiac.getZodiacChinaSign(myBirthday)
        myChinaZodiacLabel.text = NSLocalizedString(myChinaZodiacName, comment: "Chinese Zodiac")
        myChinaZodiacIcon.image = UIImage(named: myChinaZodiacName)
        let friendChinaZodiacName = Zodiac.getZodiacChinaSign(friendBirthday)
        friendChinaZodiacLabel.text = NSLocalizedString(friendChinaZodiacName, comment: "Chinese Zodiac")
        friendChinaZodiacIcon.image = UIImage(named: friendChinaZodiacName)
        let zodiacChinaComp = Zodiac.getZodiacChinaPercent(myChinaZodiacName, friendChinaZodiacName)
        chinaZodiacCompLabel.text = " " + String(zodiacChinaComp) + "%"
        
        averageCompLabel.text =  " " + String((zodiacEuroComp + zodiacChinaComp) / 2) + "%"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        if MyProfile.sharedInstance.nsBirthday != nil {
            request.birthday = MyProfile.sharedInstance.nsBirthday! as Date
            request.gender = MyProfile.sharedInstance.gender! == "male" ? .male : .female
        }
        
        bannerView.load(request)
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
