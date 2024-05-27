//
//  JobStatsCell.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import SwiftUI

struct JobStatsCell: View {
    
    let id: Int
    let title: String
    let jobDuration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("#\(id)")
                .foregroundStyle(.gray)
                .font(.system(size: 18, weight: .bold))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .foregroundStyle(.black)
                    .font(.system(size: 16, weight: .bold))
                
                Text(jobDuration)
                    .foregroundStyle(.gray)
                    .font(.system(size: 14, weight: .semibold))
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

#Preview {
    JobStatsCell(id: 121, title: "Interior design", jobDuration: "Today, 10:30 - 11:00 AM")
}
