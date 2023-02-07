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
    
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "New To-Do"
        
        // Adjust title size as this is a sub page
        navigationItem.largeTitleDisplayMode = .never
        
        // Update the save button state
        updateSaveButtonState()
    }
    
    
    // MARK: - Private Methods
    
    /// Update the save button state: enabled or disabled
    ///
    /// After each keyboard tap, this method checks if the user has entered or deleted any text,
    /// if the textfield contains no text, then the save button is disabled, otherwise, the save button is enabled
    /// The save button should be disabled if the to-do title is empty, enabled otherwise.
    /// This method is called after each keyboard tap in the `titleTextField`
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    
    // MARK: - Actions
    
    /// Is called after each keyboard tap from the user
    ///
    /// Time to check if the textfield is empty so we can update the save button state
    /// - Parameter sender: the `titleTextField` instance
    @IBAction private func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
}
