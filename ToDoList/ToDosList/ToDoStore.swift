//
//  ToDoStore.swift
//  ToDoList
//
//  Created by Anas Bashandy on 27/02/2023.
//

import Foundation

/// The data source for the ToDoListViewController.
final class ToDoStore {
    
    // MARK: - Properties
    
    /// A list of all the to-dos the user has added to the application
    ///
    /// This should be the data source of truth.
    var allToDos: [ToDo]
    
    
    // MARK: - Initialization
    
    /// Initialize a store with the user's save to-dos. If this is the first time and no to-dos were saved, then the store will be initialized with some sample to-dos.
    init() {
        allToDos = ToDo.loadToDos() ?? ToDo.loadSampleToDos()
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
