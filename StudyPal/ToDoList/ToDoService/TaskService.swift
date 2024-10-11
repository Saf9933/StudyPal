//
//  TaskService.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

class TaskService {
    
    private let db = Firestore.firestore()
    private let tasksCollection = "tasks"
    
    func fetchTasks(forUser userId: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        db.collection(tasksCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    var tasks: [Task] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let task = Task(
                            id: document.documentID,
                            title: data["title"] as? String ?? "",
                            description: data["description"] as? String,
                            priority: data["priority"] as? String ?? "Low",
                            dueDate: (data["dueDate"] as? Timestamp)?.dateValue() ?? Date(),
                            completed: data["completed"] as? Bool ?? false
                        )
                        tasks.append(task)
                    }
                    completion(.success(tasks))
                }
            }
    }
    
    func addTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "NoUser", code: 1, userInfo: nil)))
            return
        }
        
        let taskData: [String: Any] = [
            "title": task.title,
            "description": task.description ?? "",
            "priority": task.priority,
            "dueDate": Timestamp(date: task.dueDate),
            "completed": task.completed,
            "userId": userId
        ]
        
        db.collection(tasksCollection).addDocument(data: taskData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let taskId = task.id else { return }
        
        let taskData: [String: Any] = [
            "title": task.title,
            "description": task.description ?? "",
            "priority": task.priority,
            "dueDate": Timestamp(date: task.dueDate),
            "completed": task.completed
        ]
        
        db.collection(tasksCollection).document(taskId).setData(taskData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteTask(taskId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(tasksCollection).document(taskId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
