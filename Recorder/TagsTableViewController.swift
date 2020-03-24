//
//  TagsTableViewController.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/23/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

private let reuseIdentifier = "tagsCell"
private let tagRecordsSegue = "tagRecordsSegue"

class TagsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController : UISearchController!
    var filteredTags: [String] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        //SearchBar in the the navigation bar
        self.searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tags"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TagManager.FetchDistinctTags()
        tableView.reloadData()
    }
    
    // MARK: - Search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredTags = TagManager.Tags.flatMap{$0}.filter{ (tag: String) -> Bool in
            return tag.uppercased().contains(searchText.uppercased())
      }
      tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return TagManager.Tags.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTags.count
        }
        return TagManager.Tags[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = filteredTags[indexPath.item]
        } else {
            cell.textLabel?.text = TagManager.Tags[indexPath.section][indexPath.item]
        }
        return cell
    }
    
    // Segue to TagRecords Screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: tagRecordsSegue, sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == tagRecordsSegue {
            let selectedIndexPath = self.tableView.indexPathForSelectedRow!
            let tagRecordsVC = segue.destination as! TagRecordsCollectionViewController
            tagRecordsVC.tag = TagManager.Tags[selectedIndexPath.section][selectedIndexPath.item]
        }
    }

}
