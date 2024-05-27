//
//  File.swift
//  
//
//  Created by Vikas on 27/05/24.
//

import Foundation

public struct InvoiceApiModel {
    public let id = UUID()
    public let invoiceNumber: Int
    public let customerName: String
    public let total: Int
    public let status: InvoiceStatus
}

public enum InvoiceStatus: String, CaseIterable {
    case draft = "Draft"
    case pending = "Pending"
    case paid = "Paid"
    case badDebt = "Bad Debt"
}
