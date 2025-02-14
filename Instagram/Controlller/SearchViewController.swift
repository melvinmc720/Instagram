//
//  SearchViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    

    
    private var tableView = UITableView()
    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    private var posts = [post]()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCellView.self, forCellWithReuseIdentifier: ProfileCellView.identifier)
        return collectionView
    }()
    
    var filteredUsers:[User] = []
    
    var isSearching:Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    let searchController:UISearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        fetchPosts()
    
    }
    
    private func configuration(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.tableView
            .register(
                SearchViewCell.self,
                forCellReuseIdentifier:SearchViewCell.identifier
            )
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.isHidden = true
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    func fetchPosts(){
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }

}



// MARK: TableView data source
extension SearchViewController:UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchViewCell.identifier,
            for: indexPath
        ) as! SearchViewCell
        
        let user = isSearching ? filteredUsers[indexPath.row] : users?[indexPath.row]
        cell.Viewmodel = UserCellViewModel(user: user)
        return cell
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users?.count ?? 0
    }
    
     func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let user = users?[indexPath.row] else { return}
        
        let vc = ProfileViewController(user: user)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCellView.identifier,
            for: indexPath
        ) as? ProfileCellView else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller  = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        controller.Post = posts[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
}

