//
//  StorageModel.swift
//  iOSDashboardAssessment
//
//  Created by Vikas on 23/05/24.
//

import Foundation

struct Storage: Identifiable, Hashable {
    let id = UUID().uuidString
    let type: String = "ChartView"
    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}
