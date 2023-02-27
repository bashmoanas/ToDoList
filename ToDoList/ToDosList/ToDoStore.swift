//
//  ToDoStore.swift
//  ToDoList
//
//  Created by Anas Bashandy on 27/02/2023.
//

import Foundation
import UIKit

/// The data source for the ToDoListViewController.
final class ToDoStore {
    
    // MARK: - Properties
    
    /// A list of all the to-dos the user has added to the application
    ///
    /// This should be the data source of truth.
    var allToDos = [ToDo]()
    
    
    // MARK: - Initialization
    
    /// Initialize a store with the user's save to-dos. If this is the first time and no to-dos were saved, then the store will be initialized with some sample to-dos.
    init() {
        loadSavedToDos()
        registerForBackgroundNotifications()
    }
    
    
    // MARK: - Helper Properties
    
    private let toDoAchiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appending(path: "todos.plist")
    }()
    
    
    // MARK: - Helper Methods
    
    private func registerForBackgroundNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func saveChanges() -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allToDos)
            try data.write(to: toDoAchiveURL, options: .atomic)
            return true
        } catch {
            print("Error saving allToDos: \(error)")
            return false
        }
    }
    
    private func loadSavedToDos() {
        do {
            let data = try Data(contentsOf: toDoAchiveURL)
            let decoder = PropertyListDecoder()
            let toDos = try decoder.decode([ToDo].self, from: data)
            allToDos = toDos
        } catch {
            print("Error reading in saved ToDos: \(error)")
        }
    }
    
    
    // MARK: - Actions
    
    /// Create a new to-do and append it to the list of all to-dos.
    /// - Parameter toDo: the new to-do to create.
    func addNew(_ toDo: ToDo) {
        allToDos.append(toDo)
    }
    
    func remove(_ toDo: ToDo) {
        if let index = allToDos.firstIndex(of: toDo) {
            allToDos.remove(at: index)
        }
    }
    
}
