//
//  MainTabController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit
import PhotosUI

protocol MainTabBarcontrollerDelegate:AnyObject {
    func loginAuthentication()
}

class MainTabController: UITabBarController , MainTabBarcontrollerDelegate, PHPickerViewControllerDelegate {
    
    
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
        self.delegate = self
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


// MARK: TabBar controller delegate

extension MainTabController:UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = self.viewControllers?.firstIndex(of: viewController)
        if index == 2{
            presentPhotoPicker()
        }
        return true
    }
    
    func presentPhotoPicker() {
           var config = PHPickerConfiguration(photoLibrary: .shared())
           
           // Allow both photos and videos
           config.filter = .any(of: [.images, .videos])
           
           // Allow unlimited selections (0 = no limit)
           config.selectionLimit = 1
           
           // Show the most recent photos first
           config.preferredAssetRepresentationMode = .current
           
           // Show albums and smart albums
           config.selection = .ordered
           
           // Include live photos
           config.filter = .any(of: [.images, .livePhotos, .videos])
           
           let picker = PHPickerViewController(configuration: config)
        picker.modalPresentationStyle = .fullScreen
           picker.delegate = self
           present(picker, animated: true)
       }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else {
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let vc = UploadPostController()
                vc.selectedImage = image
                vc.user = self.user
                vc.delegate = self
                vc.view.backgroundColor = .systemBackground
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
        
    }
    
}

extension MainTabController:uploadPostControllerDelegate {
    func controllerdidfinishUploadingPhoto(_ controller: UploadPostController) {
        self.selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        guard let feednav = self.viewControllers?.first as? UINavigationController else {
            return
        }
        
        guard let feedvc = feednav.viewControllers.first as? FeedViewController else {
            return
        }
        
        feedvc.fetchPosts()
        
    }
    
    
}
