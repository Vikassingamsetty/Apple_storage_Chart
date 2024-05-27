//
//  AppExtensions.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import SwiftUI

// MARK: - Date + Extension
extension Date {
    
    func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        
        // Get the day of the month with suffix
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let day = Int(dayFormatter.string(from: self)) ?? 0
        let dayWithSuffix = "\(day)\(daySuffix(from: day))"
        
        // Format the full date
        dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
        var formattedDate = dateFormatter.string(from: self)
        
        // Replace the day part with the day with suffix
        if let range = formattedDate.range(of: "\(day) ") {
            formattedDate.replaceSubrange(range, with: "\(dayWithSuffix) ")
        }
        
        return formattedDate
    }
    
    private func daySuffix(from day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    }
}
