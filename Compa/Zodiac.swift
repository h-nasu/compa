//
//  Zodiac.swift
//  Compa
//
//  Created by MacBook Pro on 4/21/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import CoreData

class Zodiac {
    
    init(){}
    
    //MARK: Initialize Data
    
    class func initData() {
        
        self.initZodiacEuro()
        self.initZodiacEuroMatch()
        self.initZodiacChina()
        self.initZodiacChinaMatch()
        
    }
    
    // initialize Zodiac Euro Table
    class func initZodiacEuro() {
        if (DatabaseController.totalCount("ZodiacEuro") < 1) {
            DatabaseController.deleteAll("ZodiacEuro")
            
            let zodiacEuroArray:[[String:Any]] = [
                [
                    "name": "Aries",
                    "startDate": MyUtil.nsDateFormat("2000-03-21"),
                    "endDate": MyUtil.nsDateFormat("2000-04-19")
                ],
                [
                    "name": "Taurus",
                    "startDate": MyUtil.nsDateFormat("2000-04-20"),
                    "endDate": MyUtil.nsDateFormat("2000-05-20")
                ],
                [
                    "name": "Gemini",
                    "startDate": MyUtil.nsDateFormat("2000-05-21"),
                    "endDate": MyUtil.nsDateFormat("2000-06-21")
                ],
                [
                    "name": "Cancer",
                    "startDate": MyUtil.nsDateFormat("2000-06-22"),
                    "endDate": MyUtil.nsDateFormat("2000-07-22")
                ],
                [
                    "name": "Leo",
                    "startDate": MyUtil.nsDateFormat("2000-07-23"),
                    "endDate": MyUtil.nsDateFormat("2000-08-22")
                ],
                [
                    "name": "Virgo",
                    "startDate": MyUtil.nsDateFormat("2000-08-23"),
                    "endDate": MyUtil.nsDateFormat("2000-09-22")
                ],
                [
                    "name": "Libra",
                    "startDate": MyUtil.nsDateFormat("2000-09-23"),
                    "endDate": MyUtil.nsDateFormat("2000-10-23")
                ],
                [
                    "name": "Scorpio",
                    "startDate": MyUtil.nsDateFormat("2000-10-24"),
                    "endDate": MyUtil.nsDateFormat("2000-11-21")
                ],
                [
                    "name": "Sagittarius",
                    "startDate": MyUtil.nsDateFormat("2000-11-22"),
                    "endDate": MyUtil.nsDateFormat("2000-12-21")
                ],
                [
                    "name": "Capricorn",
                    "startDate": MyUtil.nsDateFormat("2000-12-22"),
                    "endDate": MyUtil.nsDateFormat("2001-01-19")
                ],
                [
                    "name": "Aquarius",
                    "startDate": MyUtil.nsDateFormat("2000-01-20"),
                    "endDate": MyUtil.nsDateFormat("2000-02-18")
                ],
                [
                    "name": "Pisces",
                    "startDate": MyUtil.nsDateFormat("2000-02-19"),
                    "endDate": MyUtil.nsDateFormat("2000-03-20")
                ]
                
            ]
            
            for obj in zodiacEuroArray {
                let zodiacEuro:ZodiacEuro = NSEntityDescription.insertNewObject(forEntityName: "ZodiacEuro", into: DatabaseController.getContext()) as! ZodiacEuro
                zodiacEuro.name = obj["name"] as? String
                zodiacEuro.startDate = obj["startDate"] as? NSDate
                zodiacEuro.endDate = obj["endDate"] as? NSDate
                
                DatabaseController.saveContext()
            }
        }
    }
    
    
    // Initialize Zodiac Euro Match
    class func initZodiacEuroMatch() {
        if (DatabaseController.totalCount("ZodiacEuroMatch") < 1) {
            
            DatabaseController.deleteAll("ZodiacEuroMatch")
            
            let zArray = [
                "Aries",
                "Taurus",
                "Gemini",
                "Cancer",
                "Leo",
                "Virgo",
                "Libra",
                "Scorpio",
                "Sagittarius",
                "Capricorn",
                "Aquarius",
                "Pisces"
            ]
            
            var zodiacEuroMatchCSV = Array<Dictionary<String, String>>()
            CSVScanner.runFunctionOnRowsFromFile(theColumnNames: zArray, withFileName: "ZodiacEuroMatch", withFunction: {
                (aRow:Dictionary<String, String>) in
                zodiacEuroMatchCSV.append(aRow)
            })
            zodiacEuroMatchCSV.remove(at: 0)
            
            
            for index in 0 ..< zArray.count {
                for index2 in 0 ..< zodiacEuroMatchCSV[index].count {
                    let zodiacEuroMatch:ZodiacEuroMatch = NSEntityDescription.insertNewObject(forEntityName: "ZodiacEuroMatch", into: DatabaseController.getContext()) as! ZodiacEuroMatch
                    zodiacEuroMatch.myZodiac = zArray[index]
                    zodiacEuroMatch.friendZodiac = zArray[index2]
                    zodiacEuroMatch.percent = Int16(zodiacEuroMatchCSV[index][zArray[index2]]!)!
                    
                    DatabaseController.saveContext()
                }
            }
            
        }
    }
    
    // initialize Zodiac China Table
    class func initZodiacChina() {
        if (DatabaseController.totalCount("ZodiacChina") < 1) {
            DatabaseController.deleteAll("ZodiacChina")
            
            let zodiacChinaArray:[[String:Any]] = [
                [
                    "name": "Rat",
                    "number": 4
                ],
                [
                    "name": "Ox",
                    "number": 5
                ],
                [
                    "name": "Tiger",
                    "number": 6
                ],
                [
                    "name": "Rabbit",
                    "number": 7
                ],
                [
                    "name": "Dragon",
                    "number": 8
                ],
                [
                    "name": "Snake",
                    "number": 9
                ],
                [
                    "name": "Horse",
                    "number": 10
                ],
                [
                    "name": "Goat",
                    "number": 11
                ],
                [
                    "name": "Monkey",
                    "number": 0
                ],
                [
                    "name": "Rooster",
                    "number": 1
                ],
                [
                    "name": "Dog",
                    "number": 2
                ],
                [
                    "name": "Pig",
                    "number": 3
                ]
            ]
            
            for obj in zodiacChinaArray {
                let zodiacChina:ZodiacChina = NSEntityDescription.insertNewObject(forEntityName: "ZodiacChina", into: DatabaseController.getContext()) as! ZodiacChina
                zodiacChina.name = obj["name"] as? String
                zodiacChina.number = Int16(obj["number"] as! Int)
                
                DatabaseController.saveContext()
            }
        }
    }
    
    // Initialize Zodiac China Match
    class func initZodiacChinaMatch() {
        if (DatabaseController.totalCount("ZodiacChinaMatch") < 1) {
            
            DatabaseController.deleteAll("ZodiacChinaMatch")
            
            let zArray = [
                "Rat",
                "Ox",
                "Tiger",
                "Rabbit",
                "Dragon",
                "Snake",
                "Horse",
                "Goat",
                "Monkey",
                "Rooster",
                "Dog",
                "Pig"
            ]
            
            var zodiacChinaMatchCSV = Array<Dictionary<String, String>>()
            CSVScanner.runFunctionOnRowsFromFile(theColumnNames: zArray, withFileName: "ZodiacChinaMatch", withFunction: {
                (aRow:Dictionary<String, String>) in
                zodiacChinaMatchCSV.append(aRow)
            })
            zodiacChinaMatchCSV.remove(at: 0)
            
            
            for index in 0 ..< zArray.count {
                for index2 in 0 ..< zodiacChinaMatchCSV[index].count {
                    let zodiacChinaMatch:ZodiacChinaMatch = NSEntityDescription.insertNewObject(forEntityName: "ZodiacChinaMatch", into: DatabaseController.getContext()) as! ZodiacChinaMatch
                    zodiacChinaMatch.myZodiac = zArray[index]
                    zodiacChinaMatch.friendZodiac = zArray[index2]
                    zodiacChinaMatch.percent = Int16(zodiacChinaMatchCSV[index][zArray[index2]]!)!
                    
                    DatabaseController.saveContext()
                }
            }
            
        }
    }
    
    
    //MARK: Class Functions
    
    class func calcZodiacEuro(_ resNumber: Int16) -> Int16 {
        let lowest:Double = 40
        let highest:Double = 95
        let totalScore:Double = highest - lowest
        let myScore:Double = Double(resNumber) - lowest
        let result:Double = round(myScore / totalScore * 10) * 10
        return Int16(result)
    }
    
    class func getZodiacEuroSign(_ nsDate: NSDate) -> String {
        // Convert Year to 2000 or 2001 for Capricorn Jan 1 - 19 only
        let nsDateResult = MyUtil.convertFormatForZodiacSearch(nsDate)
        let nsObj = DatabaseController.getSingleData("ZodiacEuro", NSPredicate(format: "(endDate >= %@) AND (startDate <= %@)", nsDateResult, nsDateResult))!
        return nsObj.value(forKey: "name") as! String
    }
    
    class func getZodiacEuroPercent(_ myZodiac: String, _ friendZodiac: String) -> Int16 {
        // Get Compability Percent
        let resultNSObj = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        
        return self.calcZodiacEuro(resultNSObj.value(forKey: "percent") as! Int16)
        
    }
    
    class func getZodiacChinaSign(_ nsDate: NSDate) -> String {
        let myYear: Double = Double(MyUtil.getYearFromNSDate(nsDate))
        let bufYear: Double = floor(myYear / 12)
        let zodiacChinaNum: Double = myYear - (bufYear * 12)
        let nsObj = DatabaseController.getSingleData("ZodiacChina", NSPredicate(format: "number == %d", Int16(zodiacChinaNum)))!
        return nsObj.value(forKey: "name") as! String
    }
    
    class func getZodiacChinaPercent(_ myZodiac: String, _ friendZodiac: String) -> Int16 {
        // Get Compability Percent
        let resultNSObj = DatabaseController.getSingleData("ZodiacChinaMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        return resultNSObj.value(forKey: "percent") as! Int16
    }
}
