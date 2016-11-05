//
//  HFDateExtensions.swift
//  Chronicle
//
//  Created by Kristofer Younger on 1/21/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import Foundation

//
//  NSDateISO8601.swift
//
//  Created by Kristofer Younger on 5/6/15.
//  Copyright (c) 2015 Tioga Digital. All rights reserved.
//

public extension Date {
    public static func ISOStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.string(from: date) + "Z"
    }
    public static func ISOStringForNow() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.string(from: now) + "Z"
    }
    
    public static func dateFromISOString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)!
    }
    
    public static func NiceDateFromISOString(_ string: String) -> String {
        //println("RoughDate: \(dropLast(string))")
        let newString = String(string.characters.dropLast())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let newDate = dateFormatter.date(from: newString)
        dateFormatter.dateStyle = .long //"dd mm yyyy at HH:mm"
        dateFormatter.timeStyle = .short //"dd mm yyyy at HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        return dateFormatter.string(from: newDate!)
    }
    
    public static func NiceDateTimeFromDate(_ date: Date) -> String {
        //println("RoughDate: \(dropLast(string))")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //"dd mm yyyy at HH:mm"
        dateFormatter.timeStyle = .short //"dd mm yyyy at HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        return dateFormatter.string(from: date)
    }
    
    public static func NiceDateFromDate(_ date: Date) -> String {
        //println("RoughDate: \(dropLast(string))")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //"dd mm yyyy at HH:mm"
        //dateFormatter.timeStyle = .ShortStyle //"dd mm yyyy at HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        return dateFormatter.string(from: date)
    }
    
}

extension Date
{
    func isAfterDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isBeforeDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    //    func isEqualToDate(dateToCompare : NSDate) -> Bool
    //    {
    //        //Declare Variables
    //        var isEqualTo = false
    //
    //        //Compare Values
    //        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame
    //        {
    //            isEqualTo = true
    //        }
    //
    //        //Return Result
    //        return isEqualTo
    //    }
    //
    
    
    func addDays(_ daysToAdd : Int) -> Date
    {
        let secondsInDays : TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded : Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(_ hoursToAdd : Int) -> Date
    {
        let secondsInHours : TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded : Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}
