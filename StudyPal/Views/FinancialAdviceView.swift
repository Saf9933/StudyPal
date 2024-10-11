//
//  FinancialAdviceView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI

struct FinancialAdviceView: View {
    var healthScore: Int
    var budgetRemaining: Double
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Financial Advice")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.pastelPurple)
                    
                    Text(healthScoreDescription())
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.pastelPurple.opacity(0.1))
                        .blur(radius: 5)
                        .shadow(radius: 10)
                )
                .padding(.bottom, 10)
                
                // Financial Advice Content
                VStack(alignment: .leading, spacing: 15) {
                    adviceContent()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
            .padding()
            .background(Color.lightGrayBackground.edgesIgnoringSafeArea(.all))
        }
        .navigationTitle("Financial Advice")
    }
    
    func healthScoreDescription() -> String {
        if healthScore > 75 {
            return "Great job! You're managing your finances well. Keep up the good work by continuing to stick to your budget and looking for ways to save."
        } else if healthScore > 50 {
            return "You're doing okay, but there's room for improvement. Consider setting stricter budgets or cutting back on non-essential expenses."
        } else {
            return "It looks like you might be struggling with managing your finances. Don't worry, we're here to help."
        }
    }
    
    @ViewBuilder
    func adviceContent() -> some View {
        if healthScore > 75 {
            adviceForGoodHealth()
        } else if healthScore > 50 {
            adviceForModerateHealth()
        } else {
            adviceForPoorHealth()
        }
    }
    
    @ViewBuilder
    func adviceForGoodHealth() -> some View {
        adviceTextItem("Set aside some savings each month, even if it's a small amount.")
        adviceTextItem("Keep an emergency fund for unexpected expenses.")
        adviceTextItem("Review your expenses regularly to ensure you’re staying within your budget.")
        adviceTextItem("Consider investing in a student savings account with benefits.")
    }
    
    @ViewBuilder
    func adviceForModerateHealth() -> some View {
        adviceTextItem("Take a closer look at your non-essential expenses and see where you can cut back.")
        adviceTextItem("Create a more detailed budget and stick to it.")
        adviceTextItem("Avoid impulse purchases by waiting 24 hours before buying something non-essential.")
        adviceTextItem("Look for student discounts and deals to save on daily expenses.")
    }
    
    @ViewBuilder
    func adviceForPoorHealth() -> some View {
        adviceTextItem("Consider reaching out to a financial advisor or using online resources for personalized advice.")
        adviceTextItem("Focus on paying off any debt as quickly as possible.")
        adviceTextItem("Start tracking every expense to identify where your money is going.")
        adviceTextItem("Find a part-time job that fits your schedule to boost your income.")
        adviceTextItem("Cut down on subscription services you don’t use frequently.")
    }
    
    @ViewBuilder
    func adviceTextItem(_ text: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.pastelPurple)
                .font(.title2)
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .padding(.leading, 5)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FinancialAdviceView(healthScore: 60, budgetRemaining: 200)
}
