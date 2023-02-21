//
//  DueDatePickerCell.swift
//  ToDoList
//
//  Created by Anas Bashandy on 14/02/2023.
//

import UIKit

/// The methods you use to receive updates about changes related to the `dueDate` propertiey of a given To-Do
protocol DueDatePickerCellDelegate: AnyObject {
    
    /// Informs the delegate class about the new `dueDate` picked by the user.
    ///
    ///This method is called each time the user change the date using the `UIDatePicker`.
    ///
    /// Use this method to change the ToDo model property `dueDate`, and do the necessary UI-related work to reflect this change in the model.
    /// - Parameter date: the new `dueDate` picked by the user
    func didChangedueDatePickerValue(to date: Date)
}

/// The cell that encapsulate a date picker.
final class DueDatePickerCell: UICollectionViewListCell {
    
    // MARK: - Views
    
    /// A date picker to allow the user to edit the due date for a to-do
    ///
    /// By default, the picker will show a default date that is 24hours from now.
    private let dueDatePicker = UIDatePicker()
    
    
    // MARK: - Properties
    
    /// The `DueDatePickerCell` delegate.
    ///
    /// This delegate responds to changes related to the the `dueDate` property of a given to-do. Use this delegate to respond to such changes.
    weak var delegate: DueDatePickerCellDelegate?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the `DueDatePickerCell`
    ///
    /// This should work as the single path to any UI update for the cell.
    private func configureCell() {
        configureDatePicker()
    }
    
    /// Configure the `dueDatePicker`.
    ///
    /// - Set the picker style
    /// - Add the picker as subview to the content view.
    /// - Apply constraints
    /// - Add picker action using the `valueChanged` event. Each time the user scroll picking a certain date, the delegate is informed of these changes.
    private func configureDatePicker() {
        dueDatePicker.preferredDatePickerStyle = .wheels
        
        contentView.addSubview(dueDatePicker)
                
        // Add Constraints
        dueDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dueDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dueDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dueDatePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            dueDatePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Add action
        let action = UIAction { [self] _ in
            delegate?.didChangedueDatePickerValue(to: dueDatePicker.date)
        }
        
        dueDatePicker.addAction(action, for: .valueChanged)
    }
        
    
    // MARK: -  Events
    
    /// Update the cell's `dueDate`.
    ///
    /// Use this method when registering the cell for use in the collection view.
    /// - Parameter toDo: the to-do the user is currently editing or adding or viewing
    func update(with dueDate: Date) {
        dueDatePicker.date = dueDate
    }
    
}
