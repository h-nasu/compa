//
//  Util.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import Foundation
import UIKit

import FacebookCore
import FacebookLogin

class MyUtil {

    class func nsDateFormat(_ textDate: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nsDate = dateFormatter.date(from: textDate)! as NSDate
        return nsDate
    }
    
    class func stringDateFormat(_ nsDate: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: nsDate as Date)
        return stringDate
    }
    
    class func convertFormatForZodiacSearch(_ nsDate: NSDate) -> NSDate {
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nsDate as Date)
        // Convert Year to 2000 or 2001 for Capricorn Jan 1 - 19 only
        if (components.month! == 1) && (components.day! <= 19) {
            components.year = 2001
        } else {
            components.year = 2000
        }
        components.hour = 0
        components.minute = 0
        components.second = 0
        return gregorian.date(from: components)! as NSDate
    }
    
    class func getYearFromNSDate(_ nsDate: NSDate) -> Int {
        let gregorian = Calendar(identifier: .gregorian)
        let components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nsDate as Date)
        return components.year!
    }
    
    class func convertFBDatetoDEfaultDate(_ date: String) -> NSDictionary {
        var dateArr = [String?]()
        dateArr = date.characters.split(separator: "/").map(String.init)
        let birthdayStr: String
        if !dateArr.indices.contains(2) {
            dateArr.insert("9999", at: 2)
            birthdayStr = dateArr[0]! + "-" + dateArr[1]!
        } else {
            birthdayStr = dateArr[2]! + "-" + dateArr[0]! + "-" + dateArr[1]!
        }
        let birthdayNSStr = dateArr[2]! + "-" + dateArr[0]! + "-" + dateArr[1]!
        
        return ["birthdayStr": birthdayStr, "birthdayNSStr": birthdayNSStr]
    }
    
    class func checkLoginAndNavigateToFriends(_ vc: UIViewController) {
        if AccessToken.current != nil {
            let FriendsTableVC = vc.storyboard?.instantiateViewController(withIdentifier: "FriendsTableViewController") as? FriendsTableViewController
            vc.navigationController?.pushViewController(FriendsTableVC!, animated: true)
        }
    }
    
    class func checkLoginAndNavigateToLogin(_ vc: UIViewController) {
        if AccessToken.current == nil {
            let LoginVC = vc.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            vc.navigationController?.pushViewController(LoginVC!, animated: true)
        }
    }
    
    class func fbLogin(_ vc: UIViewController, callback: @escaping ()->()) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends, .custom("user_birthday") ], viewController: vc) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                print("Logged in!")
                let connection = GraphRequestConnection()
                connection.add(FBGetRequest(nil, ["fields": "id, name, birthday, picture, gender"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        
                        // Get Logged in User Data
                        let respProfile = response.rawResponse as! NSDictionary
                        MyProfile.sharedInstance.id = respProfile["id"] as? String
                        MyProfile.sharedInstance.name = respProfile["name"] as? String
                        
                        let photoData = respProfile["picture"] as? NSDictionary
                        let photoUrl = photoData?["data"] as? NSDictionary
                        MyProfile.sharedInstance.photoUrl = photoUrl?["url"] as? String
                        
                        let date = respProfile["birthday"] as? String
                        let nsBirthday = MyUtil.convertFBDatetoDEfaultDate(date!)
                        MyProfile.sharedInstance.birthday = nsBirthday["birthdayStr"] as? String
                        MyProfile.sharedInstance.nsBirthday = MyUtil.nsDateFormat((nsBirthday["birthdayNSStr"] as? String)!)
                        MyProfile.sharedInstance.gender = respProfile["gender"] as? String
                        
                        // Callback
                        callback()
                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                
            }
        }
    }
    
    class func fbLogout() {
        let loginManager = LoginManager()
        loginManager.logOut()
        MyProfile.sharedInstance.id = nil
        MyProfile.sharedInstance.birthday = nil
        MyProfile.sharedInstance.name = nil
        MyProfile.sharedInstance.nsBirthday = nil
        MyProfile.sharedInstance.photoUrl = nil
    }
    
}


class CSVScanner {
    
    /*
    http://stackoverflow.com/questions/28802614/how-can-i-create-an-array-of-dictionary-from-a-txt-file-in-swift
 */
    
    class func debug(string:String){
        
        print("CSVScanner: \(string)")
    }
    
    class func runFunctionOnRowsFromFile(theColumnNames:Array<String>, withFileName theFileName:String, withFunction theFunction:(Dictionary<String, String>)->()) {
        
        if let strBundle = Bundle.main.path(forResource: theFileName, ofType: "csv") {
            
            let encodingError:NSError? = nil
            
            if let fileObject = try? String(contentsOfFile: strBundle, encoding: String.Encoding.utf8){
                
                var fileObjectCleaned = fileObject.replacingOccurrences(of: "\r", with: "\n")
                
                fileObjectCleaned = (fileObjectCleaned as NSString).replacingOccurrences(of: "\n\n", with: "\n")
                
                let objectArray = fileObjectCleaned.components(separatedBy:"\n")
                
                for anObjectRow in objectArray {
                    
                    let objectColumns = anObjectRow.components(separatedBy:",")
                    
                    var aDictionaryEntry = Dictionary<String, String>()
                    
                    var columnIndex = 0
                    
                    for anObjectColumn in objectColumns {
                        
                        aDictionaryEntry[theColumnNames[columnIndex]] = anObjectColumn.replacingOccurrences(of: "\"", with: "", options: String.CompareOptions.caseInsensitive, range: nil)
                        
                        columnIndex += 1
                    }
                    
                    if aDictionaryEntry.count>1{
                        theFunction(aDictionaryEntry)
                    }else{
                        
                        CSVScanner.debug(string: "No data extracted from row: \(anObjectRow) -> \(objectColumns)")
                    }
                }
            }else{
                CSVScanner.debug(string: "Unable to load csv file from path: \(strBundle)")
                
                if let errorString = encodingError?.description {
                    
                    CSVScanner.debug(string: "Received encoding error: \(errorString)")
                }
            }
        }else{
            CSVScanner.debug(string: "Unable to get path to csv file: \(theFileName).csv")
        }
    }
}


