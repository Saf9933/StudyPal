//
//  AddExpenseView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = "Food & Drink"
    @State private var date: Date = Date()
    @State private var currency: String = "USD" // Default currency
    @State var userEmail: String // Add this property to store the user's email

    var onSave: (Expense) -> Void
    
    let categories = ["Food & Drink", "Entertainment", "Transport", "Shopping"]
    let currencies = ["USD", "EUR", "CNY", "JPY"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Expense Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                
                Picker("Currency", selection: $currency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Spacer()
                
                Button(action: {
                    // Ensure that the amount entered can be converted to a Double
                    guard let amountValue = Double(amount) else {
                        // Handle invalid amount input if necessary
                        return
                    }
                    
                    // Create a new Expense object
                    let newExpense = Expense(
                        name: name,
                        amount: amountValue,
                        currency: currency,
                        category: category,
                        date: date,
                        userEmail: userEmail,
                        id: UUID().uuidString  // Generate a unique ID
                    )
                    
                    // Call the onSave closure to pass the new expense back
                    onSave(newExpense)
                    
                    // Dismiss the view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pastelPurple)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Add Expense")
        }
    }
}

// Preview
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(userEmail: "example@example.com") { _ in }
    }
}
