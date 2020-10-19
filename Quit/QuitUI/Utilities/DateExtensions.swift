//
//  DateExtensions.swift
//  Quit
//
//  Created by Alex Tudge on 26/12/2018.
//  Copyright © 2018 Alex Tudge. All rights reserved.
//

import Foundation

extension Date {
    func offsetFrom(date: Date) -> String {
        if date > Date() {
            return "Counting down to your quit date!"
        }
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        let seconds = "\(difference.second ?? 0) secs"
        let minutes = "\(difference.minute ?? 0) mins" + "\n" + seconds
        let hours = "\(difference.hour ?? 0) hours" + "\n" + minutes
        let days = "\(difference.day ?? 0) days" + "\n" + hours
        if let day = difference.day, day > 0 {
            return days
        }
        if let hour = difference.hour, hour > 0 {
            return hours
        }
        if let minute = difference.minute, minute > 0 {
            return minutes
        }
        if let second = difference.second, second > 0 {
            return seconds
        }
        return ""
    }
    
    func standardisedDate() -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let stringDate = formatter.string(from: self)
        return formatter.date(from: stringDate)!
    }
}
