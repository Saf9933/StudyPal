//
//  Expense.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import Foundation

struct Expense: Identifiable, Codable {
    var name: String
    var amount: Double
    var currency: String
    var category: String
    var date: Date
    var userEmail: String
    var id: String
    var convertedAmount: Double {
            return amount // For simplicity, return the amount as is
        }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
