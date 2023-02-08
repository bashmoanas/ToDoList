//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Anas Bashandy on 08/02/2023.
//

import UIKit

/// A custom cell to allow the user to toglle the `isComplete` property of the `ToDo` from the List
final class ToDoCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var isCompleteButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    
    // MARK: - Actions
    
    /// Update the cell's label and button using a to-do
    /// - Parameter toDo: the to-do for this exact cell
    func update(with toDo: ToDo) {
        titleLabel.text = toDo.title
        isCompleteButton.isSelected = toDo.isComplete
    }
    
}
