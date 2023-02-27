//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

/// The methods you use to communicating the changes the user made for a given to-do.
protocol ToDoDetailViewControllerDelegate: AnyObject {
    
    /// Informs the delegate when the user is ready to save the changes he made to his to-do.
    ///
    /// This methods gets called when the user taps the `saveButton`.
    ///
    /// Use this method to either:
    /// - updates an existing to-do that the user was editing.
    /// - or add a new to-do.
    /// - Parameter toDo: the edited to-do
    func didSave(_ toDo: ToDo)
}


/// The View controller that manages the view hierarchy for to-do details scene.
///
/// This view controller manages a *static* collection view, where each section represent a given property of a to-do
///
/// In total, there is 3 section:
/// - The first section contains one cell for the `isComplete` and `titleTextField` properties
/// - The second section contains two cells:
///     - One cell that acts as a section header and includes information about the due date.
///     - Another cell contains a date picker to change `dueDate` property.
/// - The third section contains a text view to manipulate the `notes` property.
final class ToDoDetailViewController: UIViewController {
    
    /// Identifiers for the scene sections
    enum Section {
        /// Contains one cell encapsulating `isCompleteButton` and the `titleTextField`
        case basicInformation
        
        /// Contains two cells.
        /// The first cell contains the `dueDateLabel` to reflect the date picked by the user
        /// The second cell contains the `dueDatePicker` to allow the user to pick a due date
        case dueDate
        
        /// Contains one cell containing the `notesTextView`
        case notes
    }
    
    /// Identifiers for the items that fit into each of the sections
    enum ItemType: Hashable {
        /// The basic info cell
        /// - Parameter toDo: the cell needs acces to the `isComplete` and `title` properties
        case basicInformation(toDo: ToDo)
        
        /// The cell that format the picked date from the user into a `String`
        /// - Parameter dueDate: the cell just needs to be passed a date in order to format it. No need to pass the whole to-do here.
        case dueDateLabel(toDo: ToDo)
        
        /// The cell that contains the date picker
        /// - Parameter dueDate: the cell just needs to be passed a date in order to adjust the picker to the selected date
        case dueDatePicker(toDo: ToDo)
        
        /// The cell that contains the `UITextView`
        /// - Parameter text: the notes that the user associate with this the given to-do
        case notes(toDo: ToDo)
    }
    
    
    // MARK: - UIViews
    
    /// A static collection view to manage the details of  a given to-do.
    private lazy var collectionView = makeCollectionView()
    
    /// Prepares the to-do data and provide it to the collection view
    private lazy var dataSource = makeDataSource()
    
    /// A save button.
    private let saveButton = UIBarButtonItem(systemItem: .save)
    
    
    // MARK: - Properties
        
    /// The To-Do the user is now editing. It can be a new To-Do to be added or an exisiting to-do to be edited
    var toDo: ToDo
        
    /// The ToDoDetailViewController Delegate
    ///
    /// The delegate responds to the user tapping the save button. Use it to respond accordingly by dismissing the detail view controller and performs the necessary steps to save the to-do.
    weak var delegate: ToDoDetailViewControllerDelegate?
    
    
    // MARK: - Initialization
    
    /// Initialize the to deo detail view controller with a to-do.
    /// - Parameter toDo: The toDo can be either an existing to-do to edit; or a blueprint for a new to-do to add.
    init(toDo: ToDo) {
        self.toDo = toDo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        // As this method is called when the view is loaded for the first time, the animation does not make sense.
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // To dismiss the keyboard more smoothly when the view is about to disappear
        view.endEditing(true)
    }
        
    
    // MARK: - Private Methods
    
    /// Prepare the view controller's view for use
    ///
    /// This should be the single path method for initial UI configurations.
    private func configureView() {
        configureNavigationBar()
        configureSaveButton()
        configureCollectionView()
        updateSaveButtonState()
    }
    
    /// Configure the navigation bar inittial state
    ///
    /// Adjust title size as this is a sub page
    /// Add the save button
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "Details"
    }
    
    /// Add the saving capabilties to the `saveButton`
    ///
    /// The saving action just inform the delegate about the changes. The saving mechanism is handled by the parent view controller.
    ///
    /// Upon saving, the view controller needs to be dismissed (if the user was adding a new toDo) or popped out (if the user was editing an existing to-do):
    ///
    /// - note: I call both `dismiss(animated:completion)` and `popViewController(animated:)`. From my testing one does not affect the other. The `dismiss(animated:completion)` is called by the presenting view controller, so if the view controller was presented using a `UINavigationController` the `dismiss` method does nothing and vice versa.
    private func configureSaveButton() {
        let action = UIAction { [self] _ in
            delegate?.didSave(toDo)
            dismiss(animated: true)
            navigationController?.popViewController(animated: true)
        }
        
        saveButton.primaryAction = action
    }
    
    /// Initialize the collection view using the list configuration layout
    private func makeCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        return UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration))
    }
    
    /// Configure the static collection view
    ///
    /// - adds the collection view as a subview.
    /// - apply collection view's constraints
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Configure the Basic Info Header Cell
    ///
    /// This method simply provide a title for the cell
    /// - Returns: Basic Info Header Cell Registration
    private func registerHeaderForBasicInfo() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, _, _ in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = "Basic Information"
            headerView.contentConfiguration = configuration
        }
    }
    
    /// Configure the Due Date Header Cell
    ///
    /// This method simply provide a title for the cell
    /// - Returns: Due Date Header Cell Registration
    private func registerHeaderForDueDate() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, _, _ in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = "Due Date"
            headerView.contentConfiguration = configuration
        }
    }
    
    /// Configure the Notes Header Cell
    ///
    /// This method simply provide a title for the cell
    /// - Returns: Notes Cell Registration
    private func registerHeaderForNotes() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, _, _ in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = "Notes"
            headerView.contentConfiguration = configuration
        }
    }
        
    /// Configure the Basic Info Cell
    /// - Returns: Basic Info Cell Registration
    private func registerCellForBasicInformation() -> UICollectionView.CellRegistration<BasicInfoCell, ItemType> {
        let cellRegistration = UICollectionView.CellRegistration<BasicInfoCell, ItemType> { [self] cell, indexPath, item in
            if case .basicInformation(_) = item {
                cell.delegate = self
                cell.update(with: toDo)
            }
        }
        return cellRegistration
    }
    
    /// Configure the Due Date Label Cell
    /// - Returns: Due Date Label Cell Registration
    private func registerCellForDueDateLabel() -> UICollectionView.CellRegistration<UICollectionViewListCell, ItemType> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ItemType> { [self] cell, indexPath, item in
            if case .dueDateLabel(_) = item {
                var content = UIListContentConfiguration.valueCell()
                content.text = "Due Date"
                content.secondaryText = toDo.dueDate.formatted(.dateTime.day().month(.defaultDigits).year(.twoDigits).hour().minute())
                
                let discolsureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: .secondaryLabel)
                cell.accessories = [.outlineDisclosure(options: discolsureOptions)]
                
                cell.contentConfiguration = content
            }
        }
        return cellRegistration
    }
    
    /// Configure the Due Date Pciker Cell
    /// - Returns: Due Date Picker Cell Registration
    private func registerCellFordueDatePicker() -> UICollectionView.CellRegistration<DueDatePickerCell, ItemType> {
        let cellRegistration = UICollectionView.CellRegistration<DueDatePickerCell, ItemType> { [self] cell, _, item in
            if case .dueDatePicker(_) = item {
                cell.delegate = self
                cell.update(with: toDo.dueDate)
            }
        }
        return cellRegistration
    }
    
    /// Configure the Notes Cell
    /// - Returns: Notes Cell Registration
    private func registerCellForNotes() -> UICollectionView.CellRegistration<NotesCell, ItemType> {
        let cellRegistration = UICollectionView.CellRegistration<NotesCell, ItemType> { [self] cell, indexPath, item in
            if case .notes(_) = item {
                cell.delegate = self
                cell.update(with: toDo.notes)
            }
        }
        return cellRegistration
    }
    
    /// Use the different cell registrations that the collection view manage and prepare them for use
    /// - Returns: The data source for the collection view
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ItemType> {
        let basicInformationCellRegistration = registerCellForBasicInformation()
        let dueDateLabelCellRegistration = registerCellForDueDateLabel()
        let dueDatePickerCellRegistration = registerCellFordueDatePicker()
        let notesCellRegistration = registerCellForNotes()
        
        dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case .basicInformation:
                return collectionView.dequeueConfiguredReusableCell(using: basicInformationCellRegistration, for: indexPath, item: item)
                
            case .dueDateLabel:
                return collectionView.dequeueConfiguredReusableCell(using: dueDateLabelCellRegistration, for: indexPath, item: item)
                
            case .dueDatePicker:
                return collectionView.dequeueConfiguredReusableCell(using: dueDatePickerCellRegistration, for: indexPath, item: item)
                
            case .notes:
                return collectionView.dequeueConfiguredReusableCell(using: notesCellRegistration, for: indexPath, item: item)
            }
        }
        
        let basicInfoHeaderRegistration = registerHeaderForBasicInfo()
        let dueDateHeaderRegistration = registerHeaderForDueDate()
        let notesHeaderRegistration = registerHeaderForNotes()
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .basicInformation:
                return collectionView.dequeueConfiguredReusableSupplementary(using: basicInfoHeaderRegistration, for: indexPath)
            case .dueDate:
                return collectionView.dequeueConfiguredReusableSupplementary(using: dueDateHeaderRegistration, for: indexPath)
            case .notes:
                return collectionView.dequeueConfiguredReusableSupplementary(using: notesHeaderRegistration, for: indexPath)
            }
        }
        
        return dataSource
    }
    
    /// Apply the current state of data to the view controller's data source at one point of time
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections([.basicInformation, .dueDate, .notes])
        snapshot.appendItems([.basicInformation(toDo: toDo)], toSection: .basicInformation)
        
        // Add the `dueDate` section
        var dueDateSectionSnapshot = NSDiffableDataSourceSectionSnapshot<ItemType>()
        let dueDateSectionHeader = ItemType.dueDateLabel(toDo: toDo)
        dueDateSectionSnapshot.append([dueDateSectionHeader])
        dueDateSectionSnapshot.append([.dueDatePicker(toDo: toDo)], to: dueDateSectionHeader)
        
        snapshot.appendItems([.notes(toDo: toDo)], toSection: .notes)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        dataSource.apply(dueDateSectionSnapshot, to: .dueDate, animatingDifferences: animatingDifferences)
    }
    
    /// Update the save button state: enabled or disabled
    ///
    /// After each keyboard tap, this method checks if the user has entered or deleted any text,
    /// if the textfield contains no text, then the save button is disabled, otherwise, the save button is enabled
    /// The save button should be disabled if the to-do title is empty, enabled otherwise.
    /// This method is called after each keyboard tap in the `titleTextField`
    private func updateSaveButtonState() {
        saveButton.isEnabled = !toDo.title.isEmpty
    }
    
}

// MARK: - ToDoDetailViewControllerDelegate


extension ToDoDetailViewController: BasicInfoCellDelegate {
    
    func didChangeToDoCompleteStatus() {
        toDo.isComplete.toggle()
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([.basicInformation(toDo: toDo)])
        dataSource.apply(snapshot)
    }
    
    func didChangeToDoTitle(to title: String?) {
        toDo.title = title ?? ""
        updateSaveButtonState()
    }
    
}


// MARK: - DueDatePickerCellDelegate

extension ToDoDetailViewController: DueDatePickerCellDelegate {
    
    func didChangedueDatePickerValue(to date: Date) {
        toDo.dueDate = date
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([.dueDateLabel(toDo: toDo)])
        dataSource.apply(snapshot)
    }
    
}


// MARK: - NoteCellDelegate

extension ToDoDetailViewController: NotesCellDelegate {
    
    func didEditToDoNotes(to notes: String) {
        toDo.notes = notes
    }
    
}
