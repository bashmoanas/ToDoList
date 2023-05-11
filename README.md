#  ToDoList

A demo project for a master-detail based app, with user input.


## Description

A ToDo manager app that manages a list of to-dos and stores it for later retrieval in a familiar table-based interface. The project consists of two screens: The first screen contains a list of user-entered to-dos, the second screen is used to both add and edit a single to-do:
- Display a list of to-dos using UICollectionView.
- Mark a to-do as completed from the custom cell in the list view.
- Swipe to delete the to-do.
- Tap on to-do to navigate to the to-do detail screen, where you can modify the to-do information.


## Architecture

The app is written using the Model View Controller using a separate store to manage the to-do list:
- The store is the data's source of truth. It has a very minimak interface that allows access to the arry of data, add a new item, or delete an item.
- The UI code is written programmatically to again maintain a single source of truth.
- The controller is currently responsible for managing the view initialization and life cycle.
- In the future, when the app get bigger, I shall use several techniques to avoid massive view controllers like: moving the UI code into UIView subclasses, using the coordinator pattern to manage navigation, have a custom delegate and data source for the UICollectionView.


## Note

This project is adapted from a project named List from Apple's [Develop in Swift](https://books.apple.com/eg/book/develop-in-swift-data-collections/id1581183203).
