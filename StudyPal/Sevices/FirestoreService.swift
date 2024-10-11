//
//  FirestoreService.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    private let db = Firestore.firestore()
    private let collection = "users"

    // Save Expense Function
    func saveExpense(_ expense: Expense, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "No User Email", code: -1, userInfo: nil)))
            return
        }

        var expenseWithUserEmail = expense
        expenseWithUserEmail.userEmail = userEmail

        do {
            let _ = try db.collection(collection)
                .document(userEmail)
                .collection("Expenses")
                .document(expense.id)
                .setData(from: expenseWithUserEmail)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    // Fetch Expenses Function
    func fetchExpenses(completion: @escaping (Result<[Expense], Error>) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "No User Email", code: -1, userInfo: nil)))
            return
        }

        db.collection(collection)
            .document(userEmail)
            .collection("Expenses")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let expenses = snapshot.documents.compactMap { document -> Expense? in
                        try? document.data(as: Expense.self)
                    }
                    completion(.success(expenses))
                }
            }
    }

    // Delete Expense Function
    func deleteExpense(_ expense: Expense, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "No User Email", code: -1, userInfo: nil)))
            return
        }

        db.collection(collection)
            .document(userEmail)
            .collection("Expenses")
            .document(expense.id)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
