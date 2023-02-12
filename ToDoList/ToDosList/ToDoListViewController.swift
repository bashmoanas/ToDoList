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
final class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoCellDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    /// A list of all the to-dos the user has added to the application
    private var toDos = [ToDo]()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.description())
        
        // Set the title of the navigation item
        title = "My To-Dos"
        
        // Make the title big as this is the main view
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set the table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Provide sample data
        toDos = ToDo.loadToDos() ?? ToDo.loadSampleToDos()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.description(), for: indexPath) as! ToDoCell
        
        // Set the delegate
        cell.delegate = self
        
        // Get the to-do to display
        let toDo = toDos[indexPath.row]
        
        // Update the cell content
        cell.update(with: toDo)
        
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
            ToDo.save(toDos)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let toDo = toDos[indexPath.row]
        
        // Navigate to ToDoDetailViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toDoDetailViewController = storyboard.instantiateViewController(withIdentifier: "toDoDetailViewController") as! ToDoDetailViewController
        toDoDetailViewController.toDo = toDo
        navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    
    // MARK: - ToDoCellDelegat
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.save(toDos)
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
        
        ToDo.save(toDos)
    }
    
    @IBAction func addToDo(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toDoDetailViewController = storyboard.instantiateViewController(withIdentifier: "toDoDetailViewController") as! ToDoDetailViewController
        let navigationController = UINavigationController(rootViewController: toDoDetailViewController)
        
        present(navigationController, animated: true)
    }
    
}
