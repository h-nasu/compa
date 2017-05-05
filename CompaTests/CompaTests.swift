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
    
    func testZodiacPercentCalcIsCorrect() {
        var result: NSManagedObject?
        var myZodiac: String
        var friendZodiac: String
        
        myZodiac = "Aries"
        friendZodiac = "Aries"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        
        XCTAssertEqual(Zodiac.calcZodiacEuro(result?.value(forKey: "percent") as! Int16), 30)
        
        myZodiac = "Libra"
        friendZodiac = "Sagittarius"
        result = DatabaseController.getSingleData("ZodiacEuroMatch", NSPredicate(format: "(myZodiac == %@) AND (friendZodiac == %@)", myZodiac, friendZodiac))!
        XCTAssertEqual(Zodiac.calcZodiacEuro(result?.value(forKey: "percent") as! Int16), 70)
    }
    
    func testCanGetCorrectCompability() {
        
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
        XCTAssertEqual(result, 10)
        
        myBirthday = MyUtil.nsDateFormat("1982-04-01")
        friendBirthday = MyUtil.nsDateFormat("1988-01-20")
        myZodiac = Zodiac.getZodiacEuroSign(myBirthday)
        friendZodiac = Zodiac.getZodiacEuroSign(friendBirthday)
        result = Zodiac.getZodiacEuroPercent(myZodiac, friendZodiac)
        XCTAssertEqual(result, 20)
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
    
}
