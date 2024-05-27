//
//  JobStatsView.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import SwiftUI
import AppData
import Combine

struct JobStatsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var selectedTab: JobStatus = .yetToStart
    var viewModel: StatsDataViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            AppHelper.dividerLine
            // MARK: - Chart View
            statsView
            
            // MARK: - Tab View
            VStack(spacing: 0) {
                AppHelper.dividerLine
                    .padding(.bottom, 10)
                scrollableTabView
                AppHelper.dividerLine
            }
            
            // MARK: - List view
            jobListView
        }
        .navigationBarBackButtonHidden()
        .background(Color.gray.opacity(0.05))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(.black)
                            .font(.title3)
                        
                        Text("Jobs (\(viewModel.jobStatusTotalCount))")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
        }
    }
}

// MARK: - Extension
extension JobStatsView {
    
    @ViewBuilder
    private var jobListView: some View {
        List {
            if let val = viewModel.jobStatusData[selectedTab] {
                ForEach(val, id: \.jobNumber) { stat in
                    let duration = AppHelper.getEventTime(startTime: stat.startTime, endTime: stat.endTime)
                    JobStatsCell(id: stat.jobNumber, title: stat.title, jobDuration: duration)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            } else {
                VStack(alignment: .center) {
                    Text("No Data")
                        .foregroundStyle(.black)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .refreshable {
            /// - NOTE: Here we can handle fetching of data from API and updating the UI.
        }
        .listStyle(.plain)
        .padding(.top, 10)
        
    }
    
    private var scrollableTabView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.getAllJobStatus, id: \.self) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }, label: {
                        VStack {
                            let statCount = viewModel.getJobStatusCount(for: index)
                            Text("\(index.rawValue)" + " " + "(\(statCount))")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedTab == index ? .black : .gray)
                                .padding(.all, 5)
                            Capsule()
                                .fill(selectedTab == index ? .indigo : .clear)
                                .frame(height: 3)
                        }
                    })
                    .frame(height: 40)
                }
            }
        }
    }
    
    private var statsView: some View {
        VStack {
            HStack {
                let totalCount = viewModel.jobStatusTotalCount
                let completedCount = viewModel.getJobStatusCount(for: .completed)
                
                
                Text("\(totalCount) Jobs")
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Text("\(completedCount) of \(totalCount) completed")
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            /// - NOTE: add chart here
            ChartView(data: viewModel.jobStorageData)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let vm = StatsDataViewModel()
    return JobStatsView(viewModel: vm)
}
