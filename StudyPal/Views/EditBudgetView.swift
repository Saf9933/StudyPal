//
//  EditBudgetView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI

struct EditBudgetView: View {
    @Binding var totalBudget: Double
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Set Your Budget")
                .font(.headline)
                .padding()

            TextField("Enter total budget", value: $totalBudget, format: .number)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)

            Button("Save") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.pastelPurple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            // Debugging print to see initial totalBudget
            print("Initial budget value: \(totalBudget)")
        }
    }
}

#Preview {
    EditBudgetView(totalBudget: .constant(0.0))
}
