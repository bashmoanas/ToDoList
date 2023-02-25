//
//  BasicInfoCell.swift
//  ToDoList
//
//  Created by Anas Bashandy on 13/02/2023.
//

import UIKit

/// The methods you use to receive updates about changes related to the `isComplete` and `title` properties of a given To-Do.
protocol BasicInfoCellDelegate: AnyObject {
    
    /// Informs the delegate class every time the user mark a To-Do as complete.
    ///
    /// The method is called each time the user taps the `isCompleteButton` to mark a To-Do as complete.
    ///
    /// Use this method to change the ToDo model property `isComplete`, and do the necessary UI-related work to reflect this change in the model.
    func didChangeToDoCompleteStatus()
    
    /// Informs the delegate class about any change the user make to the To-Do `title`.
    ///
    /// The methods is called after each keystroke when the user is editing the `titleTextField`.
    ///
    /// Use this method to update the ToDo model property `title`, and any UI-related work like enabling or disabling a save button if necessary.
    /// - Parameter title: the new edited title
    func didChangeToDoTitle(to title: String?)
}


/// The cell that encapsulates a button and a textField.
///
/// The button is just a toggle to allow the user to mark a ToDo as complete. The textField is here to allow the user to add/edit the title of a given to-do
final class BasicInfoCell: UICollectionViewListCell {
    
    // MARK: - Views
    
    /// The horizontal stack view that contains both the `isCompleteButton` and the `titleTextField`.
    private let stackView: UIStackView = UIStackView()
    
    /// A button that acts as a toggle.
    ///
    /// This is a button with no title. The button is given a `circle` image to mark a to-do is not yet complete. Once completed, the button changes its default image to use a `checkmarck.circle.fill` to mark the to-do as complete.
    private let isCompleteButton: UIButton = UIButton(type: .system)
    
    /// A textField to allow editing the to-do `title`.
    private let titleTextField = UITextField()
    
    
    // MARK: - Properties
    
    /// The `BasicInfoCell` delegate.
    ///
    /// This delegate responds to changes related to the `isComplete` and `title` properties of a given to-do. Use this delegate to respond to such changes.
    weak var delegate: BasicInfoCellDelegate?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the `BasicInfoCell`.
    ///
    /// This should work as the single path to any UI update for the cell.
    private func configureCell() {
        configureStackView()
        configureIsCompleteButton()
        configureTitleTextField()
    }
    
    /// Configure the `stackView`
    ///
    /// - Add the `stackView` as subview to the content view.
    /// - Configure stack view appearance
    /// - Add `stackView` arranged subviews
    /// - Apply constraints
    private func configureStackView() {
        contentView.addSubview(stackView)
        
        stackView.spacing = 8
        
        // Add arranged subviews
        stackView.addArrangedSubview(isCompleteButton)
        stackView.addArrangedSubview(titleTextField)
        
        // Apply constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    /// Configure the `isCompleteButton`.
    ///
    /// - Set the horizontal content hugging priority to refrain the button from any space that it doesn't require.
    /// - Add the circle image for the default state of the button.
    /// - Add the checkmark image for the `selected` state of the button.
    /// - Add the button action which simply informs the delegate that it was tapped.
    private func configureIsCompleteButton() {
        isCompleteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // Default Configuration
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "circle")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        isCompleteButton.configuration = configuration
        
        // Configure button when selected
        isCompleteButton.configurationUpdateHandler = { button in
            
            var configuration = button.configuration
            
            switch button.state {
            case .selected:
                configuration?.image = UIImage(systemName: "checkmark.circle.fill")
            default:
                configuration?.image = UIImage(systemName: "circle")
            }
            
            button.configuration = configuration
        }
        
        // Action
        let action = UIAction { [self] _ in
            delegate?.didChangeToDoCompleteStatus()
        }
        
        isCompleteButton.addAction(action, for: .primaryActionTriggered)
    }
    
    /// Configure the `titleTextField`.
    ///
    /// - Prevent the textField from sizing itself when the text becomes too long.
    /// - Add a `textField` action for the `editingChanged` event. The action simply inform the delegate that it's `text` property was changed after each keystroke.
    /// - Add another action to dismiss the keyboard when the user taps the return button.
    private func configureTitleTextField() {
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Remind me to..."
        titleTextField.font = .preferredFont(forTextStyle: .body)
        titleTextField.adjustsFontForContentSizeCategory = true
        
        titleTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let editingChangedAction = UIAction { [self] _ in
            delegate?.didChangeToDoTitle(to: titleTextField.text ?? "")
        }
        
        titleTextField.addAction(editingChangedAction, for: .editingChanged)
        
        // Dismiss the keyboard when the user taps the return button.
        let returnTappedAction = UIAction { [titleTextField] _ in
            titleTextField.resignFirstResponder()
        }
        
        titleTextField.addAction(returnTappedAction, for: .primaryActionTriggered)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isAccessibiltyCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        
        if isAccessibiltyCategory {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    
    // MARK: -  Events
    
    /// Update the cell's `isCompleteButton` and `titleTextField`.
    ///
    /// Use this method when registering the cell for use in the collection view.
    /// - Parameter toDo: the to-do the user is currently editing
    func update(with toDo: ToDo) {
        titleTextField.text = toDo.title
        isCompleteButton.isSelected = toDo.isComplete
    }
    
}
