//
//  ChartView.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    var data: [Storage]
    var isJobs: Bool = true
    
    var body: some View {
        Chart {
            ForEach(data) { item in
                BarMark(
                    x: .value("Value", item.value),
                    y: .value("Type", item.type),
                    stacking: .center)
                .foregroundStyle(by: .value("Name", "\(item.name) \(isJobs ? "" : "$")(\(item.value))"))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}
#Preview {
    ChartView(data: [])
}
