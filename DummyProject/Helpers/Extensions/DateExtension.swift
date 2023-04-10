//
//  DateExtension.swift
//  BaseProject
//
//

import Foundation
import UIKit


extension Date{
    
    //MARK:- CONVERT STRING TO DATE ,
    //PASS THE FORMAT THE DATE STRING IN CURRENTLY IN
    //IT REQUIRE TO PASS A VALID DATE FORMAT
    func getDateFromStr(str: String , newFormat: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = newFormat
        let date = formatter.date(from: str)
        return date ?? Date()
    }
    
    
    //MARK:- CHANGE DATE FORMAT
    //REQUIRED TO PASS A VALID FORMAT
    func changeFormat(newFormat: String?) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = newFormat
        let dateString = formatter.string(from: self)
        return dateString
    }
    
   
    
    //MARK:-  GET TIME AGO FOR A DATE
    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "just now"
    }
    
    
}
