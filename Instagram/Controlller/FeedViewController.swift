//
//  FeedViewController.swift
//  Instagram
//
//  Created by milad marandi on 11/14/24.
//

import UIKit


// - MARK: Collection View
class FeedViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Setup()
        fetchPosts()
    }
    
    private var posts = [post]()
    
    private func Setup(){
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "logout",
            style: .done,
            target: self,
            action: #selector(handleLogout)
        )
    }
    
    @objc func handleLogout(){
        AuthService.signout { error in
            guard error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            let vc = LogInpageController()
            vc.delegate = self.tabBarController as? MainTabController
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    

}


// MARK: - Data source
extension FeedViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = PostViewModel(post:posts[indexPath.row])
        return cell
    }
}


// MARK: - LAYOU OUT
extension FeedViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 110
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


