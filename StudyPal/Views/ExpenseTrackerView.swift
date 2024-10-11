//
//  ExpenseTrackerView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Charts

struct ExpenseTrackerView: View {
    @State private var expenses: [Expense] = []
    @State private var showingAddExpense = false
    @State private var showingEditBudget = false
    @State private var showingMonthlySummary = false
    @State private var totalBudget: Double = 0.0
    @State private var healthScore: Int = 100
    @State private var selectedTimeframe: Timeframe = .day
    @State private var currency: String = "USD"
    @State private var firestoreService = FirestoreService()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGrayBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        financialHealthScoreView
                        totalBalanceAndBudgetView
                        spendingCategoriesView
                        statisticsView
                        
                        Button(action: {
                            showingMonthlySummary = true
                        }) {
                            Text("View Monthly Summary")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.pastelPurple)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddExpenseView(userEmail: Auth.auth().currentUser?.email ?? "") { expense in
                        saveExpense(expense)
                    }
                }
                .sheet(isPresented: $showingEditBudget) {
                    EditBudgetView(totalBudget: $totalBudget)
                }
                .sheet(isPresented: $showingMonthlySummary) {
                    MonthlySummaryView(expenses: expenses)
                }
            }
            .onAppear(perform: loadExpenses)
            .navigationTitle("Expense Tracker")
            .navigationBarItems(trailing: Button(action: {
                showingAddExpense.toggle()
            }) {
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(.pastelPurple)
            })
        }
    }
    
    // Subviews
    private var financialHealthScoreView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Financial Health Score")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                NavigationLink(destination: FinancialAdviceView(healthScore: healthScore, budgetRemaining: totalBudgetRemaining)) {
                    Text("Get Advice")
                        .font(.caption)
                        .foregroundColor(.pastelPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.pastelPurple.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            Text("\(healthScore)%")
                .font(.largeTitle)
                .bold()
                .foregroundColor(healthScoreColor)
            
            ProgressView(value: Double(healthScore) / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: healthScoreColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    private var totalBalanceAndBudgetView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Total Balance (\(currency))")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    showingEditBudget = true
                }) {
                    Text("Edit Budget")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            HStack {
                Text("¥\(String(format: "%.2f", expenses.map(\.convertedAmount).reduce(0, +)))")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.pastelPurple)
                
                Spacer()
                
                Text("¥\(String(format: "%.2f", totalBudgetRemaining))")
                    .font(.title)
                    .bold()
                    .foregroundColor(totalBudgetRemaining >= 0 ? .pastelGreen : .pastelRed)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    private var spendingCategoriesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Spending Categories")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(expenseCategories(), id: \.self) { category in
                NavigationLink(destination: CategoryDetailView(category: category, expenses: expenses.filter { $0.category == category }, firestoreService: firestoreService)) {
                    HStack {
                        Text(category)
                            .font(.headline)
                        
                        Spacer()
                        
                        ProgressView(value: spendingInCategory(category) / budgetForCategory(category), total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: spendingInCategory(category) > budgetForCategory(category) ? .pastelRed : .pastelGreen))
                            .frame(width: 100)
                        
                        Text("¥\(String(format: "%.2f", spendingInCategory(category)))")
                            .font(.headline)
                            .foregroundColor(spendingInCategory(category) > budgetForCategory(category) ? .pastelRed : .pastelGreen)
                    }
                    .padding()
                    .background(Color.lightGrayBackground.opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    private var statisticsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Statistics")
                    .font(.headline)
                Spacer()
            }
            
            Picker("Timeframe", selection: $selectedTimeframe) {
                ForEach(Timeframe.allCases, id: \.self) { timeframe in
                    Text(timeframe.rawValue.capitalized).tag(timeframe)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 10)
            
            Chart {
                ForEach(expensesForSelectedTimeframe()) { expense in
                    LineMark(
                        x: .value("Date", expense.date),
                        y: .value("Amount", expense.convertedAmount)
                    )
                    .foregroundStyle(expense.amount < 0 ? Color.pastelRed : Color.pastelGreen)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // Helper Properties
    private var totalBudgetRemaining: Double {
        totalBudget - expenses.map(\.convertedAmount).reduce(0, +)
    }
    
    private var healthScoreColor: Color {
        healthScore >= 75 ? .pastelGreen : (healthScore >= 50 ? .pastelYellow : .pastelRed)
    }
    
    // Helper Functions
    private func expensesForSelectedTimeframe() -> [Expense] {
        let calendar = Calendar.current
        switch selectedTimeframe {
        case .day:
            return expenses.filter { calendar.isDateInToday($0.date) }
        case .week:
            return expenses.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
        case .month:
            return expenses.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        case .year:
            return expenses.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .year) }
        }
    }
    
    private func spendingInCategory(_ category: String) -> Double {
        return expenses
            .filter { $0.category == category }
            .map { $0.convertedAmount }
            .reduce(0, +)
    }

    private func budgetForCategory(_ category: String) -> Double {
        switch category {
        case "Food & Drink": return 300.0
        case "Entertainment": return 200.0
        case "Transport": return 150.0
        case "Shopping": return 100.0
        default: return 1000.0
        }
    }
    
    private func expenseCategories() -> [String] {
        ["Food & Drink", "Entertainment", "Transport", "Shopping"]
    }
    
    private func updateFinancialHealthScore() {
        let totalSpent = expenses.map(\.convertedAmount).reduce(0, +)
        let overspent = max(0, totalSpent - totalBudget)
        
        if totalBudget > 0 {
            healthScore = max(0, 100 - Int((overspent / totalBudget) * 100))
        } else {
            healthScore = 0
        }
    }
    
    private func saveExpense(_ expense: Expense) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email!)
        
        let expenseData: [String: Any] = [
            "name": expense.name,
            "amount": expense.amount,
            "category": expense.category,
            "currency": expense.currency,
            "date": expense.date,
            "id": expense.id,
            "userEmail": user.email!  // Ensure the email is saved
        ]
        
        userRef.collection("Expenses").document(expense.id).setData(expenseData) { error in
            if let error = error {
                print("Error saving expense: \(error.localizedDescription)")
            } else {
                print("Expense saved successfully!")
                self.expenses.append(expense)
                updateFinancialHealthScore()
            }
        }
    }


    private func loadExpenses() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email!)
        
        userRef.collection("Expenses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching expenses: \(error)")
                return
            }
            if let documents = snapshot?.documents {
                self.expenses = documents.map { doc in
                    let data = doc.data()
                    return Expense(
                        name: data["name"] as? String ?? "",
                        amount: data["amount"] as? Double ?? 0.0,
                        currency: data["currency"] as? String ?? "USD",
                        category: data["category"] as? String ?? "",
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                        userEmail: data["userEmail"] as? String ?? "",
                        id: doc.documentID
                    )
                }
                // Update the financial health score and UI
                updateFinancialHealthScore()
            }
        }
    }


    private func deleteExpense(_ expense: Expense) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email!)
        
        let expenseRef = userRef.collection("Expenses").document(expense.id)
        
        expenseRef.delete { error in
            if let error = error {
                print("Error deleting expense: \(error)")
            } else {
                print("Expense deleted successfully!")
                self.expenses.removeAll { $0.id == expense.id }
                updateFinancialHealthScore()
            }
        }
    }
}

// Monthly Summary View
struct MonthlySummaryView: View {
    var expenses: [Expense]
    
    var body: some View {
        List {
            ForEach(groupedExpensesByMonth(), id: \.key) { month, expenses in
                NavigationLink(destination: MonthlyDetailView(month: month, expenses: expenses)) {
                    HStack {
                        Text(month)
                        Spacer()
                        Text("¥\(String(format: "%.2f", expenses.map(\.convertedAmount).reduce(0, +)))")
                            .bold()
                            .foregroundColor(.pastelPurple)
                    }
                }
            }
        }
        .navigationTitle("Monthly Summary")
    }
    
    // Function to group expenses by month
    func groupedExpensesByMonth() -> [(key: String, value: [Expense])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let groupedExpenses = Dictionary(grouping: expenses) { (expense: Expense) -> String in
            return dateFormatter.string(from: expense.date)
        }
        
        return groupedExpenses.sorted { $0.key > $1.key }
    }
}

// Monthly Detail View
struct MonthlyDetailView: View {
    var month: String
    var expenses: [Expense]
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                HStack {
                    Text(expense.name)
                    Spacer()
                    Text("¥\(String(format: "%.2f", expense.convertedAmount))")
                        .foregroundColor(.pastelPurple)
                }
            }
        }
        .navigationTitle(month)
    }
}

// Enums
enum Timeframe: String, CaseIterable {
    case day, week, month, year
}

// Preview
struct ExpenseTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTrackerView()
    }
}
