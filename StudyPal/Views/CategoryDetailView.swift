//
//  CategoryDetailView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-19.
//

import SwiftUI

struct CategoryDetailView: View { // Make sure this struct conforms to View
    var category: String
    var expenses: [Expense]
    var firestoreService: FirestoreService

    var body: some View { // This is the required body property
        List {
            ForEach(expenses) { expense in
                VStack(alignment: .leading) {
                    Text(expense.name)
                        .font(.headline)
                    Text("Amount: \(expense.convertedAmount, specifier: "%.2f") \(expense.currency)")
                    Text("Date: \(expense.formattedDate)")
                }
                .swipeActions {
                    Button(role: .destructive) {
                        deleteExpense(expense)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        // Implement edit functionality here
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .navigationTitle("\(category) Details")
    }
    
    func deleteExpense(_ expense: Expense) {
        firestoreService.deleteExpense(expense) { result in
            switch result {
            case .success: break
                // Handle UI updates here (e.g., reload the list)
            case .failure(let error):
                print("Error deleting expense: \(error)")
            }
        }
    }
}

#Preview {
    CategoryDetailView(category: "Food & Drink", expenses: [], firestoreService: FirestoreService())
}
