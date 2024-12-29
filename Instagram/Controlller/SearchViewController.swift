//
//  SearchViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class SearchViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    let searchController:UISearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    
    }
    
    private func configuration(){
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }

}


// MARK: TableView data source
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = "cells"
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
}
