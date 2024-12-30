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
    
    var filteredUsers:[User] = []
    
    var isSearching:Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    let searchController:UISearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    
    }
    
    private func configuration(){
        
        self.tableView
            .register(
                SearchViewCell.self,
                forCellReuseIdentifier:SearchViewCell.identifier
            )
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableView.rowHeight = 64
        
        UserService.fetchAllUsers { users in
            self.users = users
        }
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(),let AllUsers = users , !text.isEmpty  else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        filteredUsers = AllUsers.filter({ user in
            user.username
                .lowercased()
                .contains(text) || user.fullname
                .lowercased().contains(text)
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }

}


// MARK: TableView data source
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchViewCell.identifier,
            for: indexPath
        ) as! SearchViewCell
        
        let user = isSearching ? filteredUsers[indexPath.row] : users?[indexPath.row]
        cell.Viewmodel = UserCellViewModel(user: user)
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users?.count ?? 0
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let user = users?[indexPath.row] else { return}
        
        let vc = ProfileViewController(user: user)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
