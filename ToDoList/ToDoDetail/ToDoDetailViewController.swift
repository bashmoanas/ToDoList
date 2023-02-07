//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

class ToDoDetailViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var isCompleteButton: UIButton!
    @IBOutlet private var dueDateLabel: UILabel!
    @IBOutlet private var dueDatePicker: UIDatePicker!
    @IBOutlet private var notesTextView: UITextView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "New To-Do"
        
        // Adjust title size as this is a sub page
        navigationItem.largeTitleDisplayMode = .never
    }
}
