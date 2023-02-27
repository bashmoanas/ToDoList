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
struct ToDo: Hashable, Codable {
    
    // MARK: - Properties
    
    /// A universally unique value to identify each to-do.
    ///
    /// It's given a default value in the init at initialization so that we do not worry about giving it any values at creation time,
    /// we also don't care about the id having a specific value as long as each to-do has a unique value.
    ///
    let id: UUID
    
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
    
    
    // MARK: - Initialization
    
    /// In order to implement the `Codable` protocol, `id` should not have a default value, or it can be turned into var, or which what is done here have an init and give `id` the default value it needs and keeps the `id` constant
    init(title: String, isComplete: Bool, dueDate: Date, notes: String? = nil) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    
    // MARK: - Equatable conformance
    
    /// Exclude unrelated properties that do not contribute to the equality between two to-dos instances
    ///
    /// A to-do = another to only if thei `id`s matches
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        lhs.id == rhs.id
    }
    
    
    // MARK: - Hashable Conformance
    
    /// Excludes unrelated properties from contributing to the hash algorithm
    ///
    /// Only the `id` is unique to contribute to the hashing algoritm
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
