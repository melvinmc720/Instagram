//
//  NotificationViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class NotificationViewController: UITableViewController {
    
    // MARK: - Properties
    private var notifications = [Notification](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var refresher = UIRefreshControl()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        fetchNotifications()
    }
    
    // MARK: - API
    
    func checkIfUserIsFollowed(){
        notifications.forEach { notification in
            guard notification.type == .follow else { return}
            UserService.checkIfUserIsFollowed(uid: notification.id) { isfollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}){
                    self.notifications[index].userIsFollowed = isfollowed
                }
            }
        }
    }
    
    func fetchNotifications(){
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            
        }
    }
    
    // MARK: - Helpers
    
    func configuration(){
        
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(refreshView), for: .primaryActionTriggered)
        tableView.refreshControl = refresher
        
    }
    
    @objc func refreshView(){
        if refresher.isRefreshing {
            self.notifications.removeAll()
            fetchNotifications()
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
            }
        }
       
        
    }
    
}

// MARK: - UItablview data source
extension NotificationViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else { return UITableViewCell()}
        
        cell.viewModel = NotificationViewModel(notification: self.notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}


// MARK: - UITableViewDelegate
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserService.fetchUser(withUId: notifications[indexPath.row].uid) { user in
            let controller = ProfileViewController(user: user)
            self.navigationController?.pushViewController(controller
                                                          , animated: true)
        }
    }
}


extension NotificationViewController:NotificationDelegate {
    func cell(_ cell: NotificationCell, wantstoFollow uid: String) {
        self.showLoader(true)
        UserService.follow(uid: uid) { _ in
            cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        }
        
    }
    
    func cell(_ cell: NotificationCell, wantstoUnFollow uid: String) {
        self.showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postID: String) {
        
        self.showLoader(true)
        PostService.fetchPost(withPostId: postID) { post in
            
            let vc = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.Post = post
            self.navigationController?.pushViewController(vc, animated: true)
            self.showLoader(false)
            
            
            
        }
    }
    
    
}
