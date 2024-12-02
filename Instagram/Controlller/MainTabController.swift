//
//  MainTabController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    // - MARK: LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .black
        
        let layout = UICollectionViewFlowLayout()
        
        let FeedVc = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, viewController: FeedViewController(collectionViewLayout: layout))
        
        let ImagePickerVc = templateNavigationController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, viewController: ImageSelectorViewController())
        
        let SearchVc = templateNavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, viewController: SearchViewController())
        
        let NotificationVc = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, viewController: NotificationViewController())
        
        let ProfileVc = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, viewController: ProfileViewController())
        
        self.setViewControllers([FeedVc ,SearchVc , ImagePickerVc  , NotificationVc , ProfileVc], animated: true)

    }
    
    // - MARK: Helper
    
    private func templateNavigationController(unselectedImage:UIImage , selectedImage:UIImage , viewController:UIViewController) -> UINavigationController {
        
        viewController.tabBarItem = UITabBarItem(title: nil, image: unselectedImage, selectedImage: selectedImage)
        
        let navVc = UINavigationController(rootViewController: viewController)
        navVc.navigationBar.tintColor = .black
        return navVc
        
    }


}
