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
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // loadMockData(10)
        
        // Fetch saved data from code data
        RecordManager.Fetch()
        
        // Migration
         migrationForTags()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
//    func loadMockData(_ limit: Int) {
//        for i in stride(from: 1, to: limit, by: 1) {
//            RecordManager.Save(record: Record(header: "Header\(i)", field1: "Username\(i)", field2: "Password\(i)", tag: "Tag\(i < 5 ? "Black" : "Rock")"))
//        }
//    }
    
    func migrationForTags() {
        for record in RecordManager.Records {
            RecordManager.Update(oldRecord: record, header: record.header!, field1: record.field1!, field2: record.field2!, tag: record.tag!, misc: record.misc!)
        }
    }

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
        return record.header!.lowercased().contains(searchText.lowercased()) || record.field1!.lowercased().contains(searchText.lowercased()) || record.field2!.lowercased().contains(searchText.lowercased()) || record.tag!.uppercased().contains(searchText.uppercased())
      }
      collectionView.reloadData()
    }
   
    // MARK: - Add new record
    @IBAction func AddRecord(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Record", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Header" })
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Field One" })
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Field Two" })
        alert.addTextField(configurationHandler: { textField in textField.text = DEFAULT_TAG })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in

            let header = alert.textFields![0].text!
            let field1 = alert.textFields![1].text!
            let field2 = alert.textFields![2].text!
            let tag = alert.textFields![3].text!

            RecordManager.Save(record: Record(header: header, field1: field1, field2: field2, tag: tag))
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecord: Record = RecordManager.Records[indexPath.item]
        
        let questionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        questionController.addAction(UIAlertAction(title: "Update Record", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let updateRecordAC = UIAlertController(title: "Update Record", message: nil, preferredStyle: .alert)
            updateRecordAC.addTextField(configurationHandler: { textField in textField.text = selectedRecord.header })
            updateRecordAC.addTextField(configurationHandler: { textField in textField.text = selectedRecord.field1 })
            updateRecordAC.addTextField(configurationHandler: { textField in textField.text = selectedRecord.field2 })
            updateRecordAC.addTextField(configurationHandler: { textField in textField.text = selectedRecord.tag })

            updateRecordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            updateRecordAC.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in

                let header = updateRecordAC.textFields![0].text!
                let field1 = updateRecordAC.textFields![1].text!
                let field2 = updateRecordAC.textFields![2].text!
                let tag = updateRecordAC.textFields![3].text!

                RecordManager.Update(oldRecord: selectedRecord, header: header, field1: field1, field2: field2, tag: tag, misc: selectedRecord.misc!)
                self.collectionView.reloadData()
            }))

            self.present(updateRecordAC, animated: true)
        }))
        questionController.addAction(UIAlertAction(title: "Delete Record", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            let ac = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete this record?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action:UIAlertAction!) -> Void in
                RecordManager.Delete(forRecordAt: indexPath.item)
                self.collectionView.reloadData()
            }))
            self.present(ac, animated: true, completion: nil)
        }))
        questionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(questionController, animated: true, completion: nil)
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
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
