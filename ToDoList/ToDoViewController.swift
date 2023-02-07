//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the navigation item
        title = "My To-Dos"
        
        // Make the title big as this is the main view
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
