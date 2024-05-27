//
//  StatsDataViewModel.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import Foundation
import AppData
import Combine

final class StatsDataViewModel: ObservableObject {
    
    @Published var jobStatusData: [JobStatus: [JobApiModel]] = [:]
    @Published var jobTotalStats: [JobStatus: Int] = [:]
    @Published var jobStorageData: [Storage] = []
    
    @Published var invoiceStatsData: [InvoiceStatus: [InvoiceApiModel]] = [:]
    @Published var invoiceTotalStats: [InvoiceStatus: Int] = [:]
    @Published var invoiceStorageData: [Storage] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    var getAllJobStatus: [JobStatus] {
        return JobStatus.allCases
    }
    
    func fetchDashBoardStats() {
        getJobStatusData()
        getInvoiceStatusData()
    }
}

// MARK: - Job Stats
extension StatsDataViewModel {

    var jobStatusTotalCount: Int {
        return jobTotalStats.values.reduce(0, +)
    }
    
    func getJobStatusCount(for status: JobStatus) -> Int {
        return jobTotalStats[status] ?? 0
    }
    
    private func generateRandomJobList(size: Int = 50) -> [JobApiModel] {
        return SampleData.generateRandomJobList(size: size)
    }
    
    private func getJobStatusData() {
        
        Just(generateRandomJobList()).eraseToAnyPublisher()
            .map { jobs in
                Dictionary(grouping: jobs, by: { $0.status })
            }
            .map { groupedJobs in
                let sortedKeys = groupedJobs.keys.sorted(by: self.sortJobStatuses)
                var sortedDict: [JobStatus: [JobApiModel]] = [:]
                for key in sortedKeys {
                    sortedDict[key] = groupedJobs[key]
                }
                return sortedDict
            }
            .sink { sortedGroupJobs in
                self.jobStatusData = sortedGroupJobs
                self.jobTotalStats = sortedGroupJobs.mapValues { $0.count }
                self.jobStorageData = self.jobTotalStats.map { (key, value) in
                    Storage(name: key.rawValue, value: value)
                }.sorted(by: { $0.value > $1.value })
            }.store(in: &cancellable)
    }
    
    private func sortJobStatuses(_ lhs: JobStatus, _ rhs: JobStatus) -> Bool {
        let order: [JobStatus] = getAllJobStatus
        return order.firstIndex(of: lhs)! > order.firstIndex(of: rhs)!
    }
}

// MARK: - Invoice Stats
extension StatsDataViewModel {
    
    var invoiceTotalCount: Int {
        return invoiceTotalStats.values.reduce(0, +)
    }
    
    func getInvoiceStatusCount(for status: InvoiceStatus) -> Int {
        return invoiceTotalStats[status] ?? 0
    }
    
    private func generatedRandomInvoiceList(size: Int = 50) -> [InvoiceApiModel] {
        return SampleData.generateRandomInvoiceList(size: size)
    }
    
    private func getInvoiceStatusData() {
        Just(generatedRandomInvoiceList()).eraseToAnyPublisher()
            .map { invoice in
                Dictionary(grouping: invoice, by: { $0.status })
                
            }
            .map { groupedJobs in
                let sortedKeys = groupedJobs.keys.sorted(by: self.sortInvoiceStatuses)
                var sortedDict: [InvoiceStatus: [InvoiceApiModel]] = [:]
                for key in sortedKeys {
                    sortedDict[key] = groupedJobs[key]
                }
                return sortedDict
            }
            .sink { sortedGroupJobs in
                let totalStats = sortedGroupJobs.mapValues { jobs in
                    jobs.reduce(0) { $0 + $1.total }
                }
                self.invoiceStatsData = sortedGroupJobs
                self.invoiceTotalStats = totalStats
                self.invoiceStorageData = totalStats.map { (key, value) in
                    Storage(name: key.rawValue, value: value)
                }.sorted(by: { $0.value > $1.value })
            }.store(in: &cancellable)
    }
    
    private func sortInvoiceStatuses(_ lhs: InvoiceStatus, _ rhs: InvoiceStatus) -> Bool {
        let order: [InvoiceStatus] = InvoiceStatus.allCases
        return order.firstIndex(of: lhs)! > order.firstIndex(of: rhs)!
    }
}
