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
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        fetchNotifications()
    }
    
    // MARK: - API
    
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
        
        
    }
    
}

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
        return cell
    }
}
