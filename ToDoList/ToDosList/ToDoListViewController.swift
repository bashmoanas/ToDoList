//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Anas Bashandy on 07/02/2023.
//

import UIKit

/// Manages the to-dos list views hierarchy
///
/// The view controller manages a list of to-dos in a collection view with a list layout. Currenlty the collection view encapsulates all the to-dos in one section.
final class ToDoListViewController: UIViewController {
    
    /// Identifiers for the sections of this collection view.
    enum Section {
        /// Currently contains all the items of the collection view.
        case main
    }
    
    // MARK: - UIViews
    
    /// A collection view that manages a list of to-dos.
    private lazy var collectionView = makeCollectionView()
    
    /// Prepares the to-dos data and provides it to the collection view.
    private lazy var dataSource = makeDataSource()
    
    /// Add button to allow the user to add new to-dos.
    private let addButton = UIBarButtonItem(systemItem: .add)
    
    
    // MARK: - Properties
    
    /// The To-do store containing the data source of truth and is responsible for operations like adding and deleting to-dos
    var toDoStore: ToDoStore
    
    
    // MARK: - Initialization
    
    init(toDoStore: ToDoStore) {
        self.toDoStore = toDoStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        applySnapshot(animatingDifferences: false)
    }
    
    
    // MARK: - Helper Methods
    
    /// Prepares the View Controller's view for use.
    ///
    /// This should be the single path method for initial UI Configurations.
    private func configureView() {
        configureNavigationBar()
        configureAddButton()
        configureCollectionView()
    }
    
    /// Configure the navigation Bar initial State.
    private func configureNavigationBar() {
        // Set the title of the navigation item
        title = "My To-Dos"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    /// Add the saving capabilties to the `saveButton`
    ///
    /// The saving action just inform the delegate about the changes. The saving mechanism is handled by the parent view controller.
    ///
    /// Upon saving, the view controller needs to be dismissed (if the user was adding a new toDo) or popped out (if the user was editing an existing to-do):
    ///
    /// - note: I call both `dismiss(animated:completion)` and `popViewController(animated:)`. From my testing one does not affect the other. The `dismiss(animated:completion)` is called by the presenting view controller, so if the view controller was presented using a `UINavigationController` the `dismiss` method does nothing and vice versa.
    private func configureAddButton() {
        let action = UIAction { [self] _ in
            let newToDo = ToDo(title: "New Reminder", isComplete: false, dueDate: Date())
            let toDoDetailViewController = ToDoDetailViewController(toDo: newToDo)
            toDoDetailViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: toDoDetailViewController)
            
            present(navigationController, animated: true)
        }
        
        addButton.primaryAction = action
    }
    
    /// Initializes the collection view with a `plain` appearance.
    ///
    /// - Add swipe to delete functionality.
    /// - Returns: a collection view using the list configuration layout.
    private func makeCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        // Add swipe to delete
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] action, view, completion in
                let toDoToDelete = toDoStore.allToDos[indexPath.item]
                
                var snapshot = dataSource.snapshot()
                snapshot.deleteItems([toDoToDelete])
                dataSource.apply(snapshot)
                
                toDoStore.remove(toDoToDelete)
                
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration))
    }
    
    /// Configure the collection View.
    ///
    /// - Adds the collection view as a subview.
    /// - Sets the view controller to be the collection view delegate
    /// - Apply Collection View's Constraints.
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCellForToDo() -> UICollectionView.CellRegistration<ToDoCell, ToDo> {
        return UICollectionView.CellRegistration<ToDoCell, ToDo> { [self] cell, indexPath, _ in
            let toDo = toDoStore.allToDos[indexPath.row]
            cell.delegate = self
            cell.update(with: toDo)
        }
    }
    
    /// Use the cell registration and return the adequate cell for the data source.
    /// - Returns: The data source for the collection view
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ToDo> {
        let toDoCellRegistration = registerCellForToDo()
        
        return UICollectionViewDiffableDataSource<Section, ToDo>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: toDoCellRegistration, for: indexPath, item: item)
        }
    }
    
    /// Apply the current state of data to the view controller's data source at a single point of time.
    /// - Parameter animatingDifferences: whether to animate the data changes or not depending on the situation.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ToDo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(toDoStore.allToDos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}


// MARK: - CollectionViewDelegate

extension ToDoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let toDo = toDoStore.allToDos[indexPath.row]
        
        // Navigate to ToDoDetailViewController
        let toDoDetailViewController = ToDoDetailViewController(toDo: toDo)
        toDoDetailViewController.delegate = self
        navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
}


// MARK: - ToDoCellDelegate

extension ToDoListViewController: ToDoCellDelegate {
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            toDoStore.allToDos[indexPath.row].isComplete.toggle()
            
            let toDo = toDoStore.allToDos[indexPath.row]
            
            var snapshot = dataSource.snapshot()
            snapshot.reconfigureItems([toDo])
            dataSource.apply(snapshot)
        }
    }
    
}


// MARK: - ToDoDetailViewControllerDelegate

extension ToDoListViewController: ToDoDetailViewControllerDelegate {
    
    func didSave(_ toDo: ToDo) {
        var snapshot = dataSource.snapshot()
        
        if let indexOfExistingToDo = toDoStore.allToDos.firstIndex(of: toDo) {
            // The user is editing an existing to-do
            toDoStore.allToDos[indexOfExistingToDo] = toDo
            snapshot.reconfigureItems([toDo])
        } else {
            // The user is adding a new To-Do
            toDoStore.addNew(toDo)
            snapshot.appendItems([toDo])
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
