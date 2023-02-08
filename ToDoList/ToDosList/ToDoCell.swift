//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Anas Bashandy on 08/02/2023.
//

import UIKit

/// A protocol to manage if the user has completed a to-do or not
protocol ToDoCellDelegate: AnyObject {
    /// Inform the delegate class about the cell where the user tapped the `isCompleteButton`
    ///
    /// It is called once the user taps the `isCompleteButton`
    /// Use this method to change the ToDo model property `isComplete`
    /// - Parameter sender: The exact cell where the user tapped the `isCompleteButton`
    func checkmarkTapped(sender: ToDoCell)
}

/// A custom cell to allow the user to toglle the `isComplete` property of the `ToDo` from the List
final class ToDoCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var isCompleteButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    
    // MARK: - Properties
    
    /// The delegate of the ToDoCell
    weak var delegate: ToDoCellDelegate?
    
    
    // MARK: - Actions
    
    /// Update the cell's label and button using a to-do
    /// - Parameter toDo: the to-do for this exact cell
    func update(with toDo: ToDo) {
        titleLabel.text = toDo.title
        isCompleteButton.isSelected = toDo.isComplete
    }
    
    
    // MARK: - Actions
    
    /// This method is triggered once the user tap the `isCompletedButton`
    /// Once tapped, it will inform its delegate about it, but does nothing else,
    /// The implementation will be the responsability of the delegate class which should toggle the `isComplete` property of the to-do
    /// - Parameter sender: the instance of `isCompleteButton`
    @IBAction private func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
}
