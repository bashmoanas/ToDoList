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
    
    
    // MARK: - Properties
    
    /// Track whether the date picker is hidden or not
    private var isDatePickerHidden = true
    
    /// Track the indexPath of the cell **above** the date picker cell
    ///
    /// When the user taps this cell, it should toggle the `isDatePickerHidden` property
    private let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    
    /// Track the indexPath of the date picker cell
    ///
    /// Use this property to adjust the height of the date picker cell, when it's hidden or shown
    private let datePickerIndexPath = IndexPath(row: 1, section: 1)
    
    /// Track the indexPath of the notes cell
    ///
    /// If the notes cell height is determined automatically , the result might vary if the user didn't enter any notes, the cell might appear collapsed and doesn't convey that he can enter notes.
    /// Will use this property to have a fixed height for the notes cell
    private let notesIndexPath = IndexPath(row: 0, section: 2)
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "New To-Do"
        
        // Adjust title size as this is a sub page
        navigationItem.largeTitleDisplayMode = .never
        
        // Update due date picker to reflect 1 day from now
        dueDatePicker.date = Date().addingTimeInterval(24*60*60)
        // Update the due date label using the current due date picker date
        updateDueDateLabel(with: dueDatePicker.date)
        
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
    
    /// Update the due date label based on the to-do date
    ///
    /// The due date label value needs to be changed twice:
    /// - on view did load to reflect the Today date
    /// - on each scroll on the date wheel, when the user is selecting the date or time
    ///
    /// This method updates the date label with a formatted string.
    /// - Parameter date: the to-do date
    private func updateDueDateLabel(with date: Date) {
        dueDateLabel.text = date.formatted(.dateTime
            .day().month(.defaultDigits).year(.twoDigits)
            .hour().minute())
    }
    
    
    // MARK: - Actions
    
    /// Is called after each keyboard tap from the user
    ///
    /// This method is triggered by the `editing changed` event
    /// Time to check if the textfield is empty so we can update the save button state
    /// - Parameter sender: the `titleTextField` instance
    @IBAction private func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    /// Dismiss the keyboard when the user taps the return button
    ///
    /// This method is triggered by the `Primary action triggered` event.
    /// - Parameter sender: the `titleTextField` instance
    @IBAction private func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /// Switch the is complete button image based on its state
    ///
    /// When selected, a checkmark.circle.fill will be the image; a circle otherwise
    /// - Parameter sender: the `isCompleteButton` instance
    @IBAction private func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    /// Update the date label based on the date picked by the user
    ///
    /// This method is triggered by the `valueChanged` event
    /// - Parameter sender: the `dueDatePicker` instance
    @IBAction private func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(with: sender.date)
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        // the date picker is hidden
        case datePickerIndexPath where isDatePickerHidden:
            return 0
        // the fixed height for the notes cell
        case notesIndexPath:
            return 200
        // the date picker is NOT hidden
        default:
            return UITableView.automaticDimension
        }
    }
    
    /// Providing an estimate of the heigth of rows helps the performance of loading the table view.
    /// [Apple Documentation](https://developer.apple.com/documentation/uikit/uitableview/1614925-estimatedrowheight)
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        // This estimate is based on the size from the storyboard
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
}
