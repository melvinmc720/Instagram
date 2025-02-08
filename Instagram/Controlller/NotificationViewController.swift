//
//  NotificationViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class NotificationViewController: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
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
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else { return UITableViewCell()}
        

        return cell
    }
}
