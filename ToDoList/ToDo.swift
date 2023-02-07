//
//  ToDo.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import Foundation

/// A ToDo to keep track of
///
/// A user can mark a ToDo as complete and can pick a due date.
struct ToDo: Equatable {
    
    // MARK: - Properties
    
    /// A universally unique value to identify each to-do.
    ///
    /// It's given a default value at initialization so that we do not worry about giving it any values at creation time,
    /// we also don't care about the id having a specific value as long as each to-do has a unique value.
    ///
    let id: UUID = UUID()
    
    /// The to-do title is how the user identify each to-do
    ///
    /// This shall be entered by the user himself when adding a new to-do.
    /// This should be a concise phrase about this to-do is about.
    /// For any long notes about the to-do, see the ``notes`` property
    ///
    /// ```
    /// Buy groceries
    /// Finish my homework
    /// ```
    ///
    var title: String
    
    /// Represents whether the to-do is completed or not
    ///
    /// Use this property to toggle the to-do completeness status.
    ///
    var isComplete: Bool
    
    /// The deadline by which the user should complete this to-do
    ///
    /// - Attention: Currently there is no restrictions on the date. Should the user be able to pick a date in the past for example? Apple reminders allows this behaviour for example.
    ///
    var dueDate: Date
    
    /// Allows the user to enter more details about the to-do
    ///
    /// ```
    /// // For a To-Do titled: Buy groceries
    /// Get milk, chocolate and bananas.
    /// ```
    var notes: String?
    
    
    // MARK: - Equatable conformance
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        lhs.id == rhs.id
    }
}
