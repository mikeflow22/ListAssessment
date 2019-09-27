//
//  ListsTableViewController.swift
//  ListAssessment
//
//  Created by Michael Flowers on 9/27/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import CoreData

class ListsTableViewController: UITableViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shoppinglist Items"
        ItemController.shared.fetchedResultsController.delegate = self
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Alert function
        alert()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ItemController.shared.fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ItemController.shared.fetchedResultsController.sectionIndexTitles[section] == "1" ? "Complete" : "Incomplete"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ItemController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemsTableViewCell
        let itemToPass = ItemController.shared.fetchedResultsController.object(at: indexPath)
        cell.item = itemToPass
        cell.delegate = self
        // Configure the cell...

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //delete from ps
            let itemToDelete = ItemController.shared.fetchedResultsController.object(at: indexPath)
            ItemController.shared.delete(item: itemToDelete)
            
            // Delete the row from the data source -- dont need this because the nsfrc  delegate willhandle updateing/refreshing the tableView
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
extension ListsTableViewController: ItemsTableViewCellDelegate {
    
    func checkmarkValueChanged(cell: ItemsTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell) else { return }
        let itemToToggle  = ItemController.shared.fetchedResultsController.object(at: indexpath)
        ItemController.shared.toggleItem(itemToToggle)
        //maybe reload
        tableView.reloadData()
    }
    
    func alert(){
        var itemTextField: UITextField!
        let alert = UIAlertController(title: "Add Item", message: "Please name the item", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Item Name"
            textField.keyboardType = .alphabet
            itemTextField = textField
        }
        
        let addAction =  UIAlertAction(title: "ADD", style: .default) { (_) in
            guard let name = itemTextField.text, !name.isEmpty else { return }
           ItemController.shared.createItem(name: name)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // do we have to add anything here?
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
extension ListsTableViewController: NSFetchedResultsControllerDelegate {
    //will tell the tableViewController get ready to do something.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //there was a new entry so now we need to make a new cell.
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath, let newIndexpath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexpath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSSet, with: .automatic)
        default:
            break
        }
    }
    
}
