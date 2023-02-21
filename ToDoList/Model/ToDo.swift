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
    
    
    // MARK: - Static Properties
    
    /// Get the documents directory
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    /// Create a folder for the ToDo app to store its data.
    static let archiveURL = documentsDirectory.appending(path: "todos").appendingPathExtension("plist")
    
    // MARK: - Initialization
    
    /// In order to implement the `Codable` protocol, `id` should not have a default value, or it can be turned into var, or which what is done here have an init and give `id` the default value it needs and keeps the `id` constant
    init(title: String, isComplete: Bool, dueDate: Date, notes: String? = nil) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    
    // MARK: - Static Methods
    
    /// Save ToDos
    ///
    /// Use this method to save the user-eneterd to-dos
    /// - Note: Must save all to-dos at once. Do not use to save each to-do alone.
    /// - Parameter toDos: A toDo array you need to save
    static func save(_ toDos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /// Load saved previously save to-dos
    ///
    /// Each new to-do should be saved on disk. Use this method to retrive those todos back
    /// - Returns: Saved to-dos if there is any, `nil` otherwise
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDos)
    }
    
    /// Load sample to-dos for **DEBUG** reasons
    /// - Returns: Some sample to-dos
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "Renew the ID", isComplete: false, dueDate: Date(), notes: "The ID expires next month. I need to buy a form and submit it as soon as I could.")
        let toDo2 = ToDo(title: "Call my brother", isComplete: false, dueDate: Date(), notes: "Discuss the latest Apple announcements")
        let toDo3 = ToDo(title: "Read The Swift Programming Language Book", isComplete: false, dueDate: Date())
        let toDo4 = ToDo(title: "Watch Ted Lasso", isComplete: false, dueDate: Date(), notes: "Watch season 1 and season 2 before season 3 is out")
        let toDo5 = ToDo(title: "Finish that app", isComplete: false, dueDate: Date(), notes: "Just ship it. No more refinements.")
        let toDo6 = ToDo(title: "Work at Apple", isComplete: false, dueDate: Date(), notes: "If they can ship those bugs that affects millions, why can't I")
        let toDo7 = ToDo(title: "Visit all 27 Egypt's governorates", isComplete: false, dueDate: Date())
        
        
        return [toDo1, toDo2, toDo3, toDo4, toDo5, toDo6, toDo7]
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
    
    
    static let defaultToDo = ToDo(title: "New Reminder", isComplete: false, dueDate: Date().addingTimeInterval(24*60*60))
    
}
