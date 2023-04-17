//
//  Extension+Date.swift
//  Cars
//
//  Created by Linkon Sid on 17/4/23.
//

import Foundation

extension Date {
    func getDateOfMonth() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.day, from: self)
        return weekDay
    }

    func getTime() -> (hour: Int, minute: Int, second: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        return (hour, minutes, seconds)
    }

    func getMonthName() -> String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }

    func getYearByComparingToCurrent() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let currDatecomponents = calendar.dateComponents([.year], from: currentDate)
        let givenDateComponents = calendar.dateComponents([.year], from: self)
        guard let currentYear = currDatecomponents.year, let givenYear = givenDateComponents.year, currentYear != givenYear else {
            return ""
        }
        return String(givenYear)
    }
}

extension DateFormatter {
    static let shared = DateFormatter()
}
