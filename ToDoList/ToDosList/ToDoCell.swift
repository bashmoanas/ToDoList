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
    
    // MARK: - Views
    
    /// The horizontal stack view that contains both the `isCompleteButton` and `titleLabel`
    private let stackView: UIStackView = UIStackView()
    
    /// A button with just one image
    ///
    /// By default, the image is `circle`, when selected, the image is a `checkmarck.circle.fill` to convey a to-do is complete
    private let isCompleteButton: UIButton = UIButton(type: .system)
    
    /// The label that will hold the to-do title
    private let titleLabel: UILabel = UILabel()
    
    
    // MARK: - Properties
        
    /// The delegate of the ToDoCell
    weak var delegate: ToDoCellDelegate?
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the cell
    ///
    /// This should work as the single path to any UI update for the cell
    private func configureCell() {
        configureStackView()
        configureIsCompleteButton()
    }
    
    /// Configure the `stackView`
    ///
    /// - Add the subview as subview to the content view.
    /// - Configure stack view appearance
    /// - Add arranged subviews
    /// - Apply constraints
    private func configureStackView() {
        contentView.addSubview(stackView)
        
        stackView.spacing = 8
        
        stackView.addArrangedSubview(isCompleteButton)
        stackView.addArrangedSubview(titleLabel)
        
        // Add Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    /// Configure the `isCompleteButton`
    ///
    /// - The button is configured for default state, and for selected state
    /// - Also the content hugging priority is set to not allow the button to expand
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
        let action = UIAction { _ in
            self.delegate?.checkmarkTapped(sender: self)
        }
        
        isCompleteButton.addAction(action, for: .primaryActionTriggered)
    }
    
    
    // MARK: - Actions
    
    /// Update the cell's label and button using a to-do
    /// - Parameter toDo: the to-do for this exact cell
    func update(with toDo: ToDo) {
        titleLabel.text = toDo.title
        isCompleteButton.isSelected = toDo.isComplete
    }
    
}
