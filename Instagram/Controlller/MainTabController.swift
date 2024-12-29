//
//  MainTabController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit

protocol MainTabBarcontrollerDelegate:AnyObject {
    func loginAuthentication()
}

class MainTabController: UITabBarController , MainTabBarcontrollerDelegate {
    
    func loginAuthentication() {
        UserService.fetchUser { user in
            self.user = user
        }
    }

    
    // - MARK: LifeCyle
    
    var user:User? {
        didSet{
            guard let user = user else { return }
            print("user is here \(user)")
            configuration(with: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    private func configuration(with user:User){
        let layout = UICollectionViewFlowLayout()
        
        let FeedVc = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, viewController: FeedViewController(collectionViewLayout: layout))
        
        let ImagePickerVc = templateNavigationController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, viewController: ImageSelectorViewController())
        
        let SearchVc = templateNavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, viewController: SearchViewController())
        
        let NotificationVc = templateNavigationController(
            unselectedImage: UIImage(named: "like_unselected")!
                                                        ,selectedImage: UIImage(named: "like_selected")!,
                                                          viewController: NotificationViewController()
)
        
        let profileLayout = UICollectionViewFlowLayout()
        
        let ProfileVc = templateNavigationController(
            unselectedImage: UIImage(named: "profile_unselected")!,
            selectedImage: UIImage(named: "profile_selected")!,
            viewController: ProfileViewController(user: user)
        )
        
        self.tabBar.tintColor = .label
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.unselectedItemTintColor = .label
        self.setViewControllers([FeedVc ,SearchVc , ImagePickerVc  , NotificationVc , ProfileVc], animated: true)
    }
    
    // - MARK: Helper
    
    private func templateNavigationController(unselectedImage:UIImage , selectedImage:UIImage , viewController:UIViewController) -> UINavigationController {
        
        viewController.tabBarItem = UITabBarItem(title: nil, image: unselectedImage, selectedImage: selectedImage)
        let navVc = UINavigationController(rootViewController: viewController)
        navVc.navigationBar.tintColor = .label
        return navVc
        
    }
    
    


}
