//
//  CompaTests.swift
//  CompaTests
//
//  Created by MacBook Pro on 4/21/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import XCTest
@testable import Compa
import CoreData


class CompaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            XCTAssert(true)
        }
    }
    
    func testCanReadFromCSV() {
        var myCSVContents = Array<Dictionary<String, String>>()
        CSVScanner.runFunctionOnRowsFromFile(theColumnNames: ["title", "body", "category"], withFileName: "sample", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            myCSVContents.append(aRow)
            
        })
        XCTAssertEqual(myCSVContents[2]["title"], "title 2")
    }
    
    func testZodiacEuroCanInitialize() {
        DatabaseController.deleteAll("ZodiacEuro")
        Zodiac.initZodiacEuro()
        XCTAssertEqual(DatabaseController.totalCount("ZodiacEuro"), 12)
    }
    
    func testZodiacEuroMatchCanInitialize() {
        DatabaseController.deleteAll("ZodiacEuroMatch")
        Zodiac.initZodiacEuroMatch()
        XCTAssertEqual(DatabaseController.totalCount("ZodiacEuroMatch"), 144)
    }
    
    // https://code.tutsplus.com/tutorials/core-data-and-swift-managed-objects-and-fetch-requests--cms-25068
    
    func testZodiaEuroHaveCorrectData() {
        var result: NSManagedObject?
        
        var myBirthday = MyUtil.nsDateFormat("2000-10-06")
        result = DatabaseController.getSingleData("ZodiacEuro", NSPredicate(format: "(endDate >= %@) AND (startDate <= %@)", myBirthday, myBirthday))!
        XCTAssertEqual(result?.value(forKey: "name") as! String, "Libra")
        
        myBirthday = MyUtil.nsDateFormat("2000-12-04")
        result = DatabaseController.getSingleData("ZodiacEuro", NSPredicate(format: "(endDate >= %@) AND (startDate <= %@)", myBirthday, myBirthday))!
        XCTAssertEqual(result?.value(forKey: "name") as! String, "Sagittarius")
        
        myBirthday = MyUtil.nsDateFormat("2000-12-24")
        result = DatabaseController.getSingleData("ZodiacEuro", NSPredicate(format: "(endDate >= %@) AND (startDate <= %@)", myBirthday, myBirthday))!
        XCTAssertEqual(result?.value(forKey: "name") as! String, "Capricorn")
        
        myBirthday = MyUtil.nsDateFormat("2001-01-10")
        result = DatabaseController.getSingleData("ZodiacEuro", NSPredicate(format: "(endDate >= %@) AND (startDate <= %@)", myBirthday, myBirthday))!
        XCTAssertEqual(result?.value(forKey: "name") as! String, "Capricorn")
        
        
    }
    
    func testZodiacEuroMatchHaveCorrectData() {
        var result: NSManagedObject?
        var myZodiac: String
        var friendZodiac: String
        
        myZodiac = "Aries"
        friendZodiac = "Aries"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 60)
        
        myZodiac = "Libra"
        friendZodiac = "Sagittarius"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 80)
        
        myZodiac = "Aries"
        friendZodiac = "Capricorn"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 50)
        
        myZodiac = "Capricorn"
        friendZodiac = "Aries"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 50)
        
    }
    
    func testZodiacEuroPercentCalcIsCorrect() {
        var result: NSManagedObject?
        var myZodiac: String
        var friendZodiac: String
        
        myZodiac = "Aries"
        friendZodiac = "Aries"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        
        XCTAssertEqual(Zodiac.calcZodiacEuro(result?.value(forKey: "percent") as! Int16), 40)
        
        myZodiac = "Libra"
        friendZodiac = "Sagittarius"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(Zodiac.calcZodiacEuro(result?.value(forKey: "percent") as! Int16), 70)
        
        myZodiac = "Aries"
        friendZodiac = "Virgo"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(Zodiac.calcZodiacEuro(result?.value(forKey: "percent") as! Int16), 10)
    }
    
    func testCanGetCorrectZodiacEuroCompability() {
        
        var myBirthday = MyUtil.nsDateFormat("1982-10-06")
        var friendBirthday = MyUtil.nsDateFormat("1988-12-04")
        var myZodiac = Zodiac.getZodiacEuroSign(myBirthday)
        var friendZodiac = Zodiac.getZodiacEuroSign(friendBirthday)
        var result = Zodiac.getZodiacEuroPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 70)
        
        myBirthday = MyUtil.nsDateFormat("1982-04-01")
        friendBirthday = MyUtil.nsDateFormat("1988-01-19")
        myZodiac = Zodiac.getZodiacEuroSign(myBirthday)
        friendZodiac = Zodiac.getZodiacEuroSign(friendBirthday)
        result = Zodiac.getZodiacEuroPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 20)
        
        myBirthday = MyUtil.nsDateFormat("1982-04-01")
        friendBirthday = MyUtil.nsDateFormat("1988-01-20")
        myZodiac = Zodiac.getZodiacEuroSign(myBirthday)
        friendZodiac = Zodiac.getZodiacEuroSign(friendBirthday)
        result = Zodiac.getZodiacEuroPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 30)
    }
    
    func testNSDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var textDate = "1982-10-06"
        var nsDate = dateFormatter.date(from: textDate)! as NSDate
        var result = MyUtil.convertFormatForZodiacSearch(nsDate)
        XCTAssertEqual(MyUtil.stringDateFormat(result), "2000-10-06")
        
        textDate = "1982-01-06"
        nsDate = dateFormatter.date(from: textDate)! as NSDate
        result = MyUtil.convertFormatForZodiacSearch(nsDate)
        XCTAssertEqual(MyUtil.stringDateFormat(result), "2001-01-06")
        

    }
    
    func testCalcZodiacChina() {
        // Rat 4
        // Monkey 0
        // Dog 2
        let myYear: Double = 1936
        let bufYear: Double = floor(myYear / 12)
        let zodiacChinaNum: Double = myYear - (bufYear * 12)
        XCTAssertEqual(zodiacChinaNum, 4)

    
    }
    
    func testZodiacChinaCanInitialize() {
        DatabaseController.deleteAll("ZodiacChina")
        Zodiac.initZodiacChina()
        XCTAssertEqual(DatabaseController.totalCount("ZodiacChina"), 12)
    }
    
    func testZodiacChinaMatchCanInitialize() {
        DatabaseController.deleteAll("ZodiacChinaMatch")
        Zodiac.initZodiacChinaMatch()
        XCTAssertEqual(DatabaseController.totalCount("ZodiacChinaMatch"), 144)
    }
    
    func testZodiacChinaHaveCorrectData() {
        var zodiacChinaNum = 0
        var result = DatabaseController.getSingleData("ZodiacChina", NSPredicate(format: "number == %d", zodiacChinaNum))!
        XCTAssertEqual(result.value(forKey: "name") as! String, "Monkey")
        
        zodiacChinaNum = 11
        result = DatabaseController.getSingleData("ZodiacChina", NSPredicate(format: "number == %d", zodiacChinaNum))!
        XCTAssertEqual(result.value(forKey: "name") as! String, "Goat")
 
    }
    
    func testZodiacChinaMatchHaveCorrectData() {
        var result: NSManagedObject?
        var myZodiac: String
        var friendZodiac: String
        
        myZodiac = "Rat"
        friendZodiac = "Rat"
        result = DatabaseController.getSingleData("ZodiacChinaMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 90)
        
        myZodiac = "Dog"
        friendZodiac = "Dragon"
        result = DatabaseController.getSingleData("ZodiacChinaMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(result?.value(forKey: "percent") as! Int16, 20)
    }
    
    func testCanGetCorrectZodiacChinaCompability() {
        
        var myBirthday = MyUtil.nsDateFormat("1982-10-06")
        var friendBirthday = MyUtil.nsDateFormat("1988-12-04")
        var myZodiac = Zodiac.getZodiacChinaSign(myBirthday)
        var friendZodiac = Zodiac.getZodiacChinaSign(friendBirthday)
        var result = Zodiac.getZodiacChinaPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 20)
        
        myBirthday = MyUtil.nsDateFormat("1982-10-06")
        friendBirthday = MyUtil.nsDateFormat("1980-12-04")
        myZodiac = Zodiac.getZodiacChinaSign(myBirthday)
        friendZodiac = Zodiac.getZodiacChinaSign(friendBirthday)
        result = Zodiac.getZodiacChinaPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 80)
        
        myBirthday = MyUtil.nsDateFormat("1936-10-06")
        friendBirthday = MyUtil.nsDateFormat("1980-12-04")
        myZodiac = Zodiac.getZodiacChinaSign(myBirthday)
        friendZodiac = Zodiac.getZodiacChinaSign(friendBirthday)
        result = Zodiac.getZodiacChinaPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 100)
    }
    
    /*
    func testFriendClass() {
        var friend = Friend(name: "Fafa", photo: nil, nsBirthday: MyUtil.nsDateFormat("1982-10-06"), birthday: "1982-10-06")
        XCTAssertEqual(friend?.name, "Fafa")
        
        friend = Friend(name: "", photo: nil, nsBirthday: MyUtil.nsDateFormat("1982-10-06"), birthday: "1982-10-06")
        XCTAssertNil(friend)
    }
 */
    
    
}
