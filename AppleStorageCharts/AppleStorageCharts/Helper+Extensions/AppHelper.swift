//
//  AppHelper.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import SwiftUI

struct AppHelper {
    
    static var dividerLine: some View {
        Color.gray.opacity(0.2)
            .frame(height: 2)
    }
    
    static func getEventTime(startTime: String, endTime: String) -> String {
        // Define the date formatter for the input ISO 8601 format
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Parse the input date strings
        guard let startDate = isoFormatter.date(from: startTime),
              let endDate = isoFormatter.date(from: endTime) else {
            return ""
        }
        
        // Define the date formatter for the output format
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        // Get the current date
        let now = Date()
        let calendar = Calendar.current
        
        // Format the dates according to the specified rules
        if calendar.isDate(startDate, inSameDayAs: now) {
            // Start and end time are on today's date
            let startTimeString = outputFormatter.string(from: startDate).components(separatedBy: ", ")[1]
            let endTimeString = outputFormatter.string(from: endDate).components(separatedBy: ", ")[1]
            return "Today, \(startTimeString) - \(endTimeString)"
        } else if calendar.isDate(startDate, inSameDayAs: endDate) {
            // Start and end time are on the same date but not today
            let dateString = outputFormatter.string(from: startDate).components(separatedBy: ", ")[0]
            let startTimeString = outputFormatter.string(from: startDate).components(separatedBy: ", ")[1]
            let endTimeString = outputFormatter.string(from: endDate).components(separatedBy: ", ")[1]
            return "\(dateString), \(startTimeString) - \(endTimeString)"
        } else {
            // Start and end time are on different dates
            let startString = outputFormatter.string(from: startDate)
            let endString = outputFormatter.string(from: endDate)
            return "\(startString) -> \(endString)"
        }
    }
}
