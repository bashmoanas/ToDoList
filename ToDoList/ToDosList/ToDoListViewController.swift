//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

/// Manages the to-dos list views hierarchy
///
/// It's main view is a UITableView subclass that shall contain all the user-entered to-dos.
final class ToDoListViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
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
        
        // Set the table view data source
        tableView.dataSource = self
        
        // Provide sample data
        toDos = ToDo.loadToDos() ?? ToDo.loadSampleToDos()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "toDoCellIdentifier"
        
        // Dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ToDoCell
        
        // Get the to-do to display
        let toDo = toDos[indexPath.row]
        
        // Update the cell content
        var content = cell.defaultContentConfiguration()
        content.text = toDo.title
        cell.contentConfiguration = content
        
        // return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToToDoListViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! ToDoDetailViewController
        
        if let toDo = sourceViewController.toDo {
            if let indexOfExisitingToDo = toDos.firstIndex(of: toDo) {
                toDos[indexOfExisitingToDo] = toDo
                tableView.reloadRows(at: [IndexPath(row: indexOfExisitingToDo, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    /// Navigate to the detail view controller
    ///
    /// If the user tap the plus button to add a new to-do, just navigate there,
    /// if he taps a cell to check the detail of a to-do, pass the tapped to-do to the detail view controller and perform the navigation
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailViewController? {
        let toDoDetailViewController = ToDoDetailViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell)
                // User tapped the plus button
        else { return toDoDetailViewController }
        
        // User tapped a cell
        tableView.deselectRow(at: indexPath, animated: true)
        toDoDetailViewController?.toDo = toDos[indexPath.row]
        
        return toDoDetailViewController
    }
    
}
