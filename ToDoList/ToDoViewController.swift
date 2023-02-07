//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

/// Manages the to-dos list views hierarchy
///
/// It's main view is a UITableView subclass that shall contain all the user-entered to-dos.
final class ToDoViewController: UIViewController {
    
    // MARK: - Properties
    
    /// A list of all the to-dos the user has added to the application
    private var toDos = [ToDo]()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the navigation item
        title = "My To-Dos"
        
        // Make the title big as this is the main view
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
