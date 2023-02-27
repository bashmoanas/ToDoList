//
//  NotesCell.swift
//  ToDoList
//
//  Created by Anas Bashandy on 16/02/2023.
//

import UIKit

/// The methods you use to receive updates about changes related to the `notes` propertiey of a given To-Do
protocol NotesCellDelegate: AnyObject {
    
    /// Inform the delegate class about any edits to the `notes` of a given to-do
    ///
    /// This method is called It is called each time the text in the `notesTextView` is changed.
    ///
    /// Use this method to update the ToDo model property `notes`.
    /// - Parameter notes: the new `notes` as edited by the user
    func didEditToDoNotes(to notes: String)
}

/// The cell that encapsulates a notes text view.
final class NotesCell: UICollectionViewListCell {
    
    // MARK: - Views
    
    /// A text view to allow the user to edit the notes for a to-do.
    private let notesTextView = UITextView()
    
    
    // MARK: - Properties
    
    /// The `DueDatePickerCell` delegate
    ///
    /// This delegate responds to changes related to the `notes` property of a given to-do. Use this delegate to respond to such changes.
    weak var delegate: NotesCellDelegate?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the `NotesCell`
    ///
    /// This should work as the single path to any UI update for the cell
    private func configureCell() {
        configureNotesTextView()
    }
    
    /// Configure the `notesTextView`
    ///
    /// - Add the text view as subview to the content view.
    /// - Assign this cell subclass as the delegate to the text view to receive updates each time the user edit the textView.
    /// - Apply constraints.
    private func configureNotesTextView() {
        contentView.addSubview(notesTextView)
        
        notesTextView.adjustsFontForContentSizeCategory = true
        notesTextView.font = .preferredFont(forTextStyle: .body)
        
        notesTextView.delegate = self
                
        // Add Constraints
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            notesTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            notesTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Specify the height of the notes text view
            notesTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
        
    
    // MARK: -  Events
    
    /// Update the cell's `notes`.
    ///
    /// Use this methos when configuring the cell upon registration to update the `notes` property of the to-do.
    /// - Parameter notes: Optional string representing the notes the user might add or leave as blank.
    func update(with notes: String?) {
        notesTextView.text = notes
    }
    
}

// MARK: - UITextViewDelegate Implementation

extension NotesCell: UITextViewDelegate {
    
    // This method is called each time the text view changes.
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didEditToDoNotes(to: textView.text)
    }
    
}
