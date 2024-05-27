//
//  DashBoardView.swift
//  AppleStorageCharts
//
//  Created by Vikas on 27/05/24.
//

import SwiftUI
import AppData
import Charts

struct DashBoardView: View {
    
    @StateObject var viewModel: StatsDataViewModel = StatsDataViewModel()
    @State var presentJobStatsView:Bool = false
    
    var body: some View {
        NavigationView {
            dashboardView
        }
        .onAppear {
            viewModel.fetchDashBoardStats()
        }
    }
    
    private var dashboardView: some View {
        VStack(spacing: 0) {
            // MARK: - Nav Header
            navigationHeaderView
            
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - User Info Card view
                    userInfoView
                        .padding(.top, 20)
                    NavigationLink {
                        JobStatsView(viewModel: viewModel)
                    } label: {
                        VStack(spacing: 0) {
                            titleView(for: "Job Stats")
                            AppHelper.dividerLine
                            jobStatsView
                        }
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 0) {
                        titleView(for: "Invoice Stats")
                        AppHelper.dividerLine
                        invoiceStatsView
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.gray.opacity(0.05))
        }
    }
}

// MARK: - Extension
extension DashBoardView {
    
    private func titleView(for title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.black)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(15)
    }
    private var jobStatsView: some View {
        VStack {
            HStack {
                let totalCount = viewModel.jobStatusTotalCount
                let completedCount = viewModel.getJobStatusCount(for: .completed)
                Text("\(totalCount) Jobs")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("\(completedCount) of \(totalCount) completed")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            ChartView(data: viewModel.jobStorageData)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding(.horizontal, 10)
    }
    
    private var invoiceStatsView: some View {
        VStack {
            HStack {
                let totalCount = viewModel.invoiceTotalCount
                let completedCount = viewModel.getInvoiceStatusCount(for: .paid)
                Text("Total value ($\(totalCount))")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("$\(completedCount) collected")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            ChartView(data: viewModel.invoiceStorageData, isJobs: false)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding(.horizontal, 10)
    }
    
    private var userInfoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 5) {
                    Text("Hello, Henry Jones!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                    Image("handWave")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text(Date().formatCurrentDate())
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image("profile")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.2))
                        .frame(width: 65, height: 65)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal, 20)
    }
    
    private var navigationHeaderView: some View {
        VStack(alignment: .leading) {
            Text("Dashboard")
                .foregroundStyle(.black)
                .font(.system(size: 25, weight: .bold))
                .offset(x: 20, y: 10)
            Spacer()
            Color.gray.opacity(0.2)
                .frame(height: 3)
        }
        .background(Color.white)
        .frame(height: 60)
    }
}

#Preview {
    DashBoardView()
}
