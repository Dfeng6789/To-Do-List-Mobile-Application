//
//  ViewController.swift
//  Final Project
//
//  Created by David Feng on 4/9/22.
//

import UIKit
import Firebase

class ListViewController: UITableViewController, AddItemDelegate {
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var refHandle2: DatabaseHandle!
    
    var user = ""
    var listItems = [ListItem]()
    
    func didCreate(_ listItem: ListItem) {
        dismiss(animated: true, completion : nil)
        listItems.append(listItem)
        self.ref.child("items/\(user)/\(listItems.count - 1)").setValue(["title": listItem.title, "description": listItem.description, "date": listItem.date])
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 45
        ref = Database.database().reference()
        refHandle = ref.child("items").observe(DataEventType.value, with: {
            (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    self.listItems = []
                    if let items = value[self.user] as? [NSDictionary] {
                        for item in items {
                            if let title = item["title"] as? String, let description = item["description"] as? String, let date = item["date"] as? String {
                                self.listItems.append(ListItem(title: title, description: description, date: date))
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        })
        refHandle2 = ref.child("users").observe(DataEventType.value, with: {
            (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    if let items = value[self.user] as? NSDictionary {
                        for (key, value) in items {
                            if let keyString = key as? String {
                                if keyString == "name" {
                                    if let name = value as? String {
                                        if let titleLabel = self.tableView.viewWithTag(3) as? UILabel {
                                            titleLabel.text = "\(name)'s To-Do List"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }

    @IBAction func segueToAdd(_ sender: UIStoryboardSegue) {
        performSegue(withIdentifier: "TableToAdd", sender: sender)
    }
    
    //- Basic table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellIdentifer") else {
            fatalError("Failed to dequeue.")
        }
        if (indexPath.row <= listItems.count - 1 ) {
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = listItems[indexPath.row].title
            }
            if let subtitle = cell.viewWithTag(2) as? UILabel {
                subtitle.text = listItems[indexPath.row].date
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    // Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        performSegue(withIdentifier: "TableToDetail", sender: indexPath.row)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableToDetail" {
            if let destVC = segue.destination as? DetailViewController {
                if let index = sender as? Int {
                    destVC.listItem = listItems[index]
                    destVC.index = index
                    destVC.user = self.user
                }
            }
        }
        if segue.identifier == "TableToAdd" {
            if let destVC = segue.destination as? UINavigationController {
                if let addVC = destVC.topViewController as? AddItemViewController {
                    addVC.delegate = self
                }
            }
        }
        if segue.identifier == "TableToEdit" {
            if let destVC = segue.destination as? EditAccountViewController {
                destVC.user = self.user
            }
        }
    }
    
    // Swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.ref.child("items/\(user)").removeValue()
            if (listItems.count != 0) {
                for i in 0...(listItems.count - 1) {
                    print(i)
                    self.ref.child("items/\(user)/\(i)").setValue(["title": listItems[i].title, "description": listItems[i].description, "date": listItems[i].date])
                }
            }
        }
        tableView.reloadData()
        return
    }
    
    @IBAction func accountUnwind(_ sender: UIStoryboardSegue) {

    }
}

