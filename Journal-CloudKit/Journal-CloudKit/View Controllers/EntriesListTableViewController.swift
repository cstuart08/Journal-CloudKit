//
//  EntriesListTableViewController.swift
//  Journal-CloudKit
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import UIKit

class EntriesListTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        EntryController.sharedInstance.fetchEntries { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.sharedInstance.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entriesCell", for: indexPath)
        let entry = EntryController.sharedInstance.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = "\(entry.timestamp)"
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.sharedInstance.entries[indexPath.row]
            EntryController.sharedInstance.deleteEntries(entry: entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetail" {
            guard let indexOfEntry = tableView.indexPathForSelectedRow,
                let destVC = segue.destination as? EntryViewController else { return }
            let entry = EntryController.sharedInstance.entries[indexOfEntry.row]
            destVC.entry = entry
        }
    }
}
