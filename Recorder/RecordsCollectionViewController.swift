//
//  RecordsCollectionViewController.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/21/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

private let reuseIdentifier = "recordCell"
private let headerReuseIdentifier = "recordsHeader"

class RecordsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    var searchController : UISearchController!
    var filteredRecords: [Record] = []
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

        // Do any additional setup after loading the view.
        //SearchBar in the the navigation bar
        self.searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Records"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // loadMockData()
        
        // Fetch saved data from code data
        RecordManager.Fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
//    func loadMockData() {
//        for i in stride(from: 1, to: 10, by: 1) {
//            RecordManager.Save(record: Record(header: "Header\(i)", field1: "Username\(i)", field2: "Password\(i)"))
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredRecords = RecordManager.Records.filter { (record: Record) -> Bool in
        return record.header!.lowercased().contains(searchText.lowercased()) || record.field1!.lowercased().contains(searchText.lowercased()) || record.field2!.lowercased().contains(searchText.lowercased())
      }
      collectionView.reloadData()
    }
   
    // MARK: - Add new record
    @IBAction func AddRecord(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Record", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Header" })
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Field One" })
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Field Two" })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in

            let header = alert.textFields![0]
            let field1 = alert.textFields![1]
            let field2 = alert.textFields![2]

            RecordManager.Save(record: Record(header: header.text!, field1: field1.text!, field2: field2.text!))
            self.collectionView.reloadData()
        }))

        self.present(alert, animated: true)
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        return headerView
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecords.count
        }
        return RecordManager.Records.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecordCollectionViewCell
        
        if isFiltering {
            cell.record = filteredRecords[indexPath.item]
        } else {
            cell.record = RecordManager.Records[indexPath.item]
        }
        return cell
    }
    
    // TODO: Update cell
    // TODO: Delete cell
    // TODO: Slide right-to-left to delete
    // TODO: Slide left-to-right to update

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
